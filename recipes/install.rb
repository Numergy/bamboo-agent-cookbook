# -*- coding: utf-8 -*-
#
# Cookbook Name::bamboo-agent
# Recipe:: install
#
# Copyright 2014, Numergy
#
# All rights reserved - Do Not Redistribute
#

bamboo_config = node['bamboo-agent']
user = bamboo_config['user']

server_url = "#{node['bamboo-agent']['server']['protocol']}://#{node['bamboo-agent']['server']['address']}:#{node['bamboo-agent']['server']['port']}"

bamboo_config['agents'].each do |agent|
  if agent.key?('capabilities')
    capabilities = agent[:capabilities]
  else
    capabilities = {}
  end

  if agent.key?('wrapper_conf_properties')
    wrapper_conf_properties = agent[:wrapper_conf_properties]
  else
    wrapper_conf_properties = {}
  end

  fail ArgumentError, "\"#{agent[:id]}\" is not a valid agent id" unless agent[:id] =~  /\A[-\w]+\z/
  fail ArgumentError, 'capabilities is not a Hash' unless capabilities.is_a?(Hash)
  fail ArgumentError, 'wrapper_conf_properties is not an Hash' unless wrapper_conf_properties.is_a?(Hash)

  home_directory = "#{bamboo_config['install_dir']}/agent#{agent[:id]}-home"
  script_path = "#{home_directory}/bin/bamboo-agent.sh"
  service_name = "bamboo-agent#{agent[:id]}"

  directory home_directory do
    owner user['name']
    group user['group']
    mode '0755'
    action :create
  end

  execute "install-agent#{agent[:id]}" do
    path ['/bin', '/usr/bin', '/usr/local/bin']
    user user['name']
    group user['group']
    command "java -Dbamboo.home=#{home_directory} -jar #{bamboo_config['installer_jar']} '#{server_url}/agentServer' install"
    creates script_path
    action :run
  end

  template "/etc/init.d/#{service_name}" do
    source 'init-script.erb'
    owner 'root'
    group 'root'
    mode '755'
    variables user: user['name'], script: "#{home_directory}/bin/bamboo-agent.sh", agent_id: agent[:id]
    action :create
  end

  service service_name do
    action [:enable, :restart]
  end

  capabilities = bamboo_config[:capabilities].merge(capabilities)

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

    tmp_dir_props = {}
    tmp_dir_props['set.TMP'] = agent_tmp
    tmp_dir_props['wrapper.java.additional.3'] = "-Djava.io.tmpdir=#{agent_tmp}"

    package 'tmpwatch' do
      action :install
    end

    cron "agent#{agent[:id]}-tmp-cleanup" do
      command "/usr/sbin/tmpwatch 10d #{agent_tmp}"
    end
  else
    tmp_dir_props = {}
  end

  tmp_dir_props['wrapper.app.parameter.2'] = "#{server_url}/agentServer/"
  tmp_dir_props.merge(wrapper_conf_properties)
  wrapper_path = "#{home_directory}/conf/wrapper.conf"
  augeas_props = []
  tmp_dir_props.each do |key, value|
    augeas_props << "set /files#{wrapper_path}/#{key} #{value}"
  end

  cookbook_file "cd_properties.lns-agent#{agent[:id]}" do
    source 'augeas/lenses/cd_properties.aug'
    path '/usr/share/augeas/lenses/dist/cd_properties.aug'
    owner 'root'
    group 'root'
    mode '0644'
  end

  file wrapper_path do
    owner user['name']
    group user['group']
    action :create
  end

  augeas "update-wrapper-agent#{agent[:id]}" do
    lens 'CD_Properties.lns'
    incl wrapper_path
    changes augeas_props
    notifies :restart, "service[#{service_name}]", :delayed
  end
end
