# -*- coding: utf-8 -*-
#
require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

ChefSpec::Coverage.start! { add_filter 'bamboo-agent' }

require 'chef/application'
