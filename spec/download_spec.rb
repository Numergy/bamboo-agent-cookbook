# encoding: UTF-8
# coding: UTF-8
# -*- coding: UTF-8 -*-
#
require_relative 'spec_helper'

describe 'bamboo-agent::download' do
  subject { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates bamboo user' do
    expect(subject).to create_group('bamboo')
    expect(subject).to create_user('bamboo').with(
      supports: { manage_home: true },
      shell: '/bin/bash',
      group: 'bamboo'
    )
  end

  it 'creates install directory' do
    expect(subject).to create_directory('install-dir').with(
      path: '/usr/local/bamboo',
      owner: 'bamboo',
      group: 'bamboo',
      mode: '0755'
    )
    expect(subject).to_not reload_ohai('reload_passwd').with(
      plugin: 'etc'
    )
  end

  it 'downloads installer' do
    expect(subject).to create_remote_file_if_missing('bamboo-agent-installer').with(
      source: 'http://localhost:8085/agentServer/agentInstaller',
      path: '/usr/local/bamboo/bamboo-agent-installer.jar',
      mode: '0644',
      owner: 'bamboo',
      group: 'bamboo'
    )
  end
end
