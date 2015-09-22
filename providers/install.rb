# -*- coding: utf-8 -*-
#
# Cookbook Name:: bamboo-agent
# Providers:: install
#
# Copyright 2014, Numergy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
action :run do
  bamboo_config  = node['bamboo-agent']
  user           = bamboo_config['user']
  server_url     = bamboo_config['server']['url']
  home_directory = "#{bamboo_config['install_dir']}/agent#{new_resource.id}-home"
  script_path    = "#{home_directory}/bin/bamboo-agent.sh"
  service_name   = "bamboo-agent#{new_resource.id}"

  tmp_dir_props = {}
  expanded = {}
  augeas_props = []

  # merge global and agent custom capabilities
  capabilities   = new_resource.capabilities.merge(bamboo_config[:capabilities])

  directory home_directory do
    owner user['name']
    group user['group']
    mode '0755'
    action :create
  end

  execute "install-agent#{new_resource.id}" do
    environment 'PATH' => "/bin:/usr/bin:/usr/local/bin:#{ENV['PATH']}"
    user user['name']
    group user['group']
    command "java -Dbamboo.home=#{home_directory} -jar #{bamboo_config['installer_jar']} '#{server_url}/agentServer' install"
    creates script_path
    action :run
  end

  template "/etc/init.d/#{service_name}" do
    cookbook 'bamboo-agent'
    source 'init-script.erb'
    owner 'root'
    group 'root'
    mode '755'
    variables user: user['name'], script: "#{home_directory}/bin/bamboo-agent.sh", agent_id: new_resource.id
    action :create
    notifies :restart, "service[#{service_name}]", :delayed
  end

  service service_name do
    action [:enable, :start]
    supports restart: true, status: true
  end

  expand = lambda do |value|
    value.to_s.gsub('!ID!', new_resource.id.to_s)
  end

  capabilities.each_pair do |key, value|
    expanded[expand.call(key)] = expand.call(value)
  end

  template "#{home_directory}/bin/bamboo-capabilities.properties" do
    cookbook 'bamboo-agent'
    owner user['name']
    group user['group']
    mode '0644'
    variables capabilities: expanded
    source 'capabilities.properties.erb'
    action :create
  end

  if new_resource.private_tmp_dir == true
    agent_tmp = "#{home_directory}/.agent_tmp"
    directory agent_tmp do
      owner user['name']
      group user['group']
      mode '0755'
      action :create
    end

    tmp_dir_props['set.TMP'] = agent_tmp
    tmp_dir_props['wrapper.java.additional.3'] = "-Djava.io.tmpdir=#{agent_tmp}"

    package 'tmpwatch' do
      action :install
    end

    cron "agent#{new_resource.id}-tmp-cleanup" do
      command "/usr/sbin/tmpwatch 10d #{agent_tmp}"
    end
  end

  tmp_dir_props['wrapper.app.parameter.2'] = "#{server_url}/agentServer/"
  tmp_dir_props.merge(new_resource.wrapper_conf_properties)
  wrapper_path = "#{home_directory}/conf/wrapper.conf"
  tmp_dir_props.each do |key, value|
    augeas_props << "set /files#{wrapper_path}/#{key} #{value}"
  end

  cookbook_file "cd_properties.lns-agent#{new_resource.id}" do
    cookbook 'bamboo-agent'
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

  augeas "update-wrapper-agent#{new_resource.id}" do
    lens 'CD_Properties.lns'
    incl wrapper_path
    changes augeas_props
    notifies :restart, "service[#{service_name}]", :delayed
  end

  new_resource.updated_by_last_action(true)
end
