# encoding: UTF-8
# coding: UTF-8
# -*- coding: UTF-8 -*-
#
require_relative '../spec_helper'

describe 'bamboo-agent::install' do
  describe 'with wrong agent capabilities' do
    let(:subject) do
      ChefSpec::Runner.new do |node|
        node.set['bamboo-agent']['agents'] = [
          {
            id: 'this is wrong id'
          }
        ]
      end.converge(described_recipe)
    end

    it 'should fail' do
      expect { subject }.to raise_error(ArgumentError, /is not a valid agent id/)
    end
  end

  describe 'with wrong agent capabilities' do
    let(:subject) do
      ChefSpec::Runner.new do |node|
        node.set['bamboo-agent']['agents'] = [
          {
            id: '1',
            capabilities: 'string'
          }
        ]
      end.converge(described_recipe)
    end

    it 'should fail' do
      expect { subject }.to raise_error(ArgumentError, /capabilities is not a Hash/)
    end
  end

  describe 'with wrong agent wrapper_conf_properties' do
    let(:subject) do
      ChefSpec::Runner.new do |node|
        node.set['bamboo-agent']['agents'] = [
          {
            id: '1',
            capabilities: {},
            wrapper_conf_properties: 'string'
          }
        ]
      end.converge(described_recipe)
    end

    it 'should fail' do
      expect { subject }.to raise_error(ArgumentError, /wrapper_conf_properties is not an Array/)
    end
  end

  describe 'with parameters' do
    let(:subject) do
      ChefSpec::Runner.new do |node|
        node.set['bamboo-agent']['agents'] = [
          {
            id: '1',
            capabilities: {},
            wrapper_conf_properties: []
          }
        ]
      end.converge(described_recipe)
    end

    it 'should install agent' do
      expect(subject).to create_directory('/usr/local/bamboo/agent1-home').with(
        owner: 'bamboo',
        group: 'bamboo',
        mode: '0755'
      )

      expect(subject).to run_execute('install-agent1').with(
        path: ['/bin', '/usr/bin', '/usr/local/bin'],
        user: 'bamboo',
        group: 'bamboo',
        command: 'java -Dbamboo.home=/usr/local/bamboo/agent1-home -jar /usr/local/bamboo/bamboo-agent-installer.jar http://localhost:8085 install',
        creates: '/usr/local/bamboo/agent1-home/bin/bamboo-agent.sh'
      )

      expect(subject).to create_template('/etc/init.d/bamboo-agent1').with(
        user: 'root',
        group: 'root',
        source: 'init.d/service.erb'
      )

      expect(subject).to start_service('bamboo-agent1')
      expect(subject).to enable_service('bamboo-agent1')

      expect(subject).to create_template('/usr/local/bamboo/agent1-home/bin/bamboo-capabilities.properties').with(
        user: 'bamboo',
        group: 'bamboo',
        mode: '0644',
        source: 'capabilities.properties.erb'
      )

      expect(subject).to create_file('/usr/local/bamboo/agent1-home/conf/wrapper.conf').with(
        user: 'bamboo',
        group: 'bamboo'
      )

      expect(subject).to run_augeas('update-wrapper-agent1').with(
        lens: 'CD_Properties.lns',
        incl: '/usr/local/bamboo/agent1-home/conf/wrapper.conf',
        changes: []
      )
    end
  end
  describe 'with capabilities and wrapper conf parameters' do
    let(:subject) do
      ChefSpec::Runner.new do |node|
        node.set['bamboo-agent']['agents'] = [
          {
            id: '1',
            capabilities: {
              'system.builder.command.Bash' => '/bin/bash'
            },
            wrapper_conf_properties: [
              'set wrapper.java.maxmemory 4096'
            ],
            private_tmp_dir: true
          }
        ]
      end.converge(described_recipe)
    end

    it 'should install agent' do
      expect(subject).to create_directory('/usr/local/bamboo/agent1-home/.agent_tmp').with(
        owner: 'bamboo',
        group: 'bamboo',
        mode: '0755'
      )

      expect(subject).to install_package('tmpwatch')
      expect(subject).to create_cron('agent1-tmp-cleanup').with(
        command: '/usr/sbin/tmpwatch 10d /usr/local/bamboo/agent1-home/.agent_tmp'
      )

      expect(subject).to create_template('/usr/local/bamboo/agent1-home/bin/bamboo-capabilities.properties').with(
        user: 'bamboo',
        group: 'bamboo',
        mode: '0644',
        source: 'capabilities.properties.erb',
        variables: { capabilities: { 'system.builder.command.Bash' => '/bin/bash' } }
      )

      expect(subject).to create_file('/usr/local/bamboo/agent1-home/conf/wrapper.conf').with(
        user: 'bamboo',
        group: 'bamboo'
      )

      expect(subject).to run_augeas('update-wrapper-agent1').with(
        lens: 'CD_Properties.lns',
        incl: '/usr/local/bamboo/agent1-home/conf/wrapper.conf',
        changes: [
          "set set.TMP '/usr/local/bamboo/agent1-home/.agent_tmp'",
          "set wrapper.java.additional.3 '-Djava.io.tmpdir=/usr/local/bamboo/agent1-home/.agent_tmp'",
          'set wrapper.java.maxmemory 4096'
        ]
      )
    end
  end
end
