# encoding: UTF-8
# coding: UTF-8
# -*- coding: UTF-8 -*-
# Added by ChefSpec
require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'bamboo-agent' }

require 'chef/application'
