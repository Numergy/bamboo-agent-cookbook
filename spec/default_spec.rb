# -*- coding: utf-8 -*-
#
require_relative 'spec_helper'

describe 'bamboo-agent::default' do
  subject { ChefSpec::Runner.new.converge(described_recipe) }

  # Write full examples using the `expect` syntax
  it 'does includes recipes' do
    expect(subject).to include_recipe('apt')
    expect(subject).to include_recipe('augeas::geminstall')
    expect(subject).to include_recipe('java')
    expect(subject).to include_recipe('bamboo-agent::download')
    expect(subject).to include_recipe('bamboo-agent::install')
  end
end
