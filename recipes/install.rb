# -*- coding: utf-8 -*-
#
# Cookbook Name::bamboo-agent
# Recipe:: install
#
# Copyright 2014, Numergy
#
# All rights reserved - Do Not Redistribute
#

node['bamboo-agent']['agents'].each do |agent|
  bamboo_agent_install agent[:id] do
    id agent[:id]
    capabilities agent[:capabilities]
    wrapper_conf_properties agent[:wrapper_conf_properties]
    private_tmp_dir agent[:private_tmp_dir]
  end
end
