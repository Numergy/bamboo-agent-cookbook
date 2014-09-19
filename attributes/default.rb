# -*- coding: utf-8 -*-
#
default['bamboo-agent']['server']['address'] = 'localhost'
default['bamboo-agent']['server']['protocol'] = 'http'
default['bamboo-agent']['server']['port'] = 8085
default['bamboo-agent']['server']['url'] = "#{node['bamboo-agent']['server']['protocol']}://#{node['bamboo-agent']['server']['address']}:#{node['bamboo-agent']['server']['port']}"

default['bamboo-agent']['install_dir'] = '/usr/local/bamboo'
default['bamboo-agent']['installer_jar'] = "#{node['bamboo-agent']['install_dir']}/bamboo-agent-installer.jar"

default['bamboo-agent']['user']['name'] = 'bamboo'
default['bamboo-agent']['user']['group'] = 'bamboo'
default['bamboo-agent']['user']['manage'] = true
default['bamboo-agent']['user']['shell'] = '/bin/bash'

default['bamboo-agent']['capabilities'] = {}
default['bamboo-agent']['agents'] = []
