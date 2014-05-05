# encoding: UTF-8
# coding: UTF-8
# -*- coding: UTF-8 -*-
#
require 'serverspec'

include SpecInfra::Helper::Exec
include SpecInfra::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.os = backend(Serverspec::Commands::Base).check_os
  end
  c.path = '/sbin:/usr/sbin:/usr/bin:/bin'
end
