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

user user['name'] do
  supports manage_home: user['manage']
  group user['group']
  shell user['shell']
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
