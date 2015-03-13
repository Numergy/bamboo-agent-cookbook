# -*- coding: utf-8 -*-
#
# Cookbook Name::bamboo-agent
# Recipe:: download
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

bamboo_config = node['bamboo-agent']
user = bamboo_config['user']

group user['group'] do
  action :create
end

ohai 'reload_passwd' do
  action :nothing
  plugin 'etc'
end

user user['name'] do
  supports manage_home: user['manage']
  home "/home/#{user['name']}"
  gid user['group']
  shell user['shell']
  notifies :reload, 'ohai[reload_passwd]', :immediately
  action :create
end

directory 'install-dir' do
  path bamboo_config['install_dir']
  owner user['name']
  group user['group']
  mode '0755'
  action :create
end

server_config = bamboo_config['server']
remote_file 'bamboo-agent-installer' do
  source "#{server_config['url']}/agentServer/agentInstaller"
  path bamboo_config['installer_jar']
  mode '0644'
  owner user['name']
  group user['group']
  action :create_if_missing
end
