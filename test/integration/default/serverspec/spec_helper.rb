# -*- coding: utf-8 -*-
#
require 'serverspec'

set :backend, :exec
set :path, '$PATH:/sbin:/usr/sbin:/usr/bin:/bin'

begin
  require 'rspec_junit_formatter'
rescue LoadError
  require 'rubygems/dependency_installer'
  Gem::DependencyInstaller.new.install('rspec_junit_formatter')
  require 'rspec_junit_formatter'
end
