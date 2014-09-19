# -*- coding: utf-8 -*-
#
require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'bamboo-agent' }

require 'chef/application'
