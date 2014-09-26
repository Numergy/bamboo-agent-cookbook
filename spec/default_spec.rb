# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'debian=>bamboo-agent::default' do
  # speedup thing as you don't use mocking
  cached(:subject) do
    runner = ChefSpec::Runner.new(platform: 'debian', version: '7.4')
    runner.converge('bamboo-agent::default')
  end

  # Write full examples using the `expect` syntax
  it 'does includes recipes' do
    expect(subject).to include_recipe('apt')
    expect(subject).to include_recipe('augeas::geminstall')
    expect(subject).to include_recipe('java')
    expect(subject).to include_recipe('bamboo-agent::download')
    expect(subject).to include_recipe('bamboo-agent::install')
  end
end

describe 'centos=>bamboo-agent::default' do
  # speedup thing as you don't use mocking
  cached(:subject) do
    runner = ChefSpec::Runner.new(platform: 'centos', version: '6.0')
    runner.converge('bamboo-agent::default')
  end

  # Write full examples using the `expect` syntax
  it 'does includes recipes' do
    expect(subject).to include_recipe('yum')
    expect(subject).to include_recipe('augeas::geminstall')
    expect(subject).to include_recipe('java')
    expect(subject).to include_recipe('bamboo-agent::download')
    expect(subject).to include_recipe('bamboo-agent::install')
  end
end
