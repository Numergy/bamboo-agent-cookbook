# -*- coding: utf-8 -*-
#
# Cookbook Name:: bamboo-agent
# Resource:: install
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
actions :run
default_action :run

attribute :id, kind_of: String, regex: /^[-\w]+$/, name_attribute: true
attribute :capabilities, kind_of: Hash, default: {}
attribute :wrapper_conf_properties, kind_of: Hash, default: {}
attribute :private_tmp_dir, kind_of: [TrueClass, FalseClass], default: false

# Default action for Chef <= 10.8
def initialize(*args)
  super
  @action = :run
end
