# encoding: UTF-8
# coding: UTF-8
# -*- coding: UTF-8 -*-
#
# Cookbook Name::bamboo-agent
# Recipe:: default
#
# Copyright 2014, Numergy
#
# All rights reserved - Do Not Redistribute
#

bamboo_config = node['bamboo-agent']
user = bamboo_config['user']

bamboo_config['agents'].each do |agent|
  fail ArgumentError, "\"#{agent[:id]}\" is not a valid agent id" unless agent[:id] =~  /\A[-\w]+\z/
  fail ArgumentError, 'capabilities is not a Hash' unless agent.key?('capabilities') && agent[:capabilities].is_a?(Hash)
  fail ArgumentError, 'wrapper_conf_properties is not a Hash' unless agent.key?('wrapper_conf_properties') && agent[:wrapper_conf_properties].is_a?(Hash)

  home_directory = "#{user['install_dir']}/agent#{agent[:id]}-home"
  script_path = "#{home_directory}/bin/bamboo-agent.sh"
  service_name "bamboo-agent#{id}"

  directory home_directory do
    owner user['name']
    group user['group']
    mode '0755'
    action :create
  end

  execute "install-agent#{id}" do
    path ['/bin', '/usr/bin', '/usr/local/bin']
    user user['name']
    group user['group']
    command "java -Dbamboo.home=#{home_directory} -jar #{bamboo_config['installer_jar']} #{bamboo_config['server']['url']} install"
    creates script_path
    action :run
  end

  template "/etc/init.d/#{service}" do
    owner 'root'
    group 'root'
    mode '0755'
    variables user: user['name'], script: script_path, agent_id: agent[:id]
    source 'init.d/service.erb'
  end

  service service_name do
    action [:enable, :start]
  end

  capabilities = bamboo_config[:capabilities].merge(agent[:capabilities])

  macro = '!ID!'
  expand = lambda do |value|
    value.to_s.gsub(macro, agent[:id].to_s)
  end

  expanded = {}
  capabilities.each_pair do |key, value|
    expanded[expand.call(key)] = expand.call(value)
  end

  template "#{home_directory}/bin/bamboo-capabilities.properties" do
    owner user['name']
    group user['group']
    mode '0644'
    variables capabilities: expanded
    source 'capabilities.properties.erb'
    action :create
  end

  if agent['private_tmp_dir'] == true
    agent_tmp = "#{home_directory}/.agent_tmp"
    directory agent_tmp do
      owner user['name']
      group user['group']
      mode '0755'
      action :create
    end

    tmp_dir_props = [
      "set set.TMP '#{agent_tmp}'",
      "set wrapper.java.additional.3 '-Djava.io.tmpdir=#{agent_tmp}'"
    ]

    package 'tmpwatch' do
      action :install
    end

    cron "#{agent_tmp}-tmp-cleanup" do
      command "/usr/sbin/tmpwatch 10d #{agent_tmp}"
    end
  else
    tmp_dir_props = {}
  end

  wrapper_path = "#{home_directory}/conf/wrapper.conf"
  file wrapper_path do
    owner user['name']
    group user['group']
    action :create
  end

  augeas "update-#{wrapper_path}-properties" do
    lens 'CD_Properties.lns'
    incl wrapper_path
    changes tmp_dir_props
    notifies :start, "service[#{service_name}]", :delayed
  end
end
