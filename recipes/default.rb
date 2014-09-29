# -*- coding: utf-8 -*-
#
# Cookbook Name::bamboo-agent
# Recipe:: default
#
# Copyright 2014, Numergy
#
# All rights reserved - Do Not Redistribute
#

node.default['apt']['compile_time_update'] = true
case node['platform']
when 'debian', 'ubuntu'
  include_recipe 'apt'
when 'redhat', 'centos', 'fedora'
  include_recipe 'yum'
end

include_recipe 'augeas::geminstall'
include_recipe 'java'
include_recipe 'bamboo-agent::download'
include_recipe 'bamboo-agent::install'
