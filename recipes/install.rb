# -*- coding: utf-8 -*-
#
# Cookbook Name::bamboo-agent
# Recipe:: install
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

node['bamboo-agent']['agents'].each do |agent|
  bamboo_agent_install agent[:id] do
    id agent[:id]
    capabilities agent[:capabilities]
    wrapper_conf_properties agent[:wrapper_conf_properties]
    private_tmp_dir agent[:private_tmp_dir]
  end
end
