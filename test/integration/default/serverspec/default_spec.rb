# encoding: UTF-8
# coding: UTF-8
# -*- coding: UTF-8 -*-
#
require 'spec_helper'

describe group('bamboo') do
  it { should exist }
end

describe user('bamboo') do
  it { should exist }
end

describe file('/usr/local/bamboo/bamboo-agent-installer.jar') do
  it { should be_file }
  it { should be_owned_by 'bamboo' }
  it { should be_grouped_into 'bamboo' }
end

%w(1 2).each do |agent_id|
  describe file("/usr/local/bamboo/agent#{agent_id}-home") do
    it { should be_directory }
    it { should be_owned_by 'bamboo' }
    it { should be_grouped_into 'bamboo' }
  end

  describe file("/etc/init.d/bamboo-agent#{agent_id}") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe service("bamboo-agent#{agent_id}") do
    it { should be_running }
    it { should be_enabled }
  end
end
