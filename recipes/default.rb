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

include_recipe 'apt'
resources(execute: 'apt-get-update').run_action(:run)

include_recipe 'augeas::geminstall'
include_recipe 'java'
include_recipe 'bamboo-agent::download'
include_recipe 'bamboo-agent::install'
