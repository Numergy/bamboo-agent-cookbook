# -*- coding: utf-8 -*-
#
# Cookbook Name::bamboo-agent
# Recipe:: default
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

node.default['apt']['compile_time_update'] = true
case node['platform']
when 'debian', 'ubuntu'
  include_recipe 'apt'
when 'redhat', 'centos', 'fedora'
  include_recipe 'yum'
end

node.default['build-essential']['compile_time'] = true
include_recipe 'build-essential'

include_recipe 'augeas::geminstall'
include_recipe 'java'
include_recipe 'bamboo-agent::download'
include_recipe 'bamboo-agent::install'
