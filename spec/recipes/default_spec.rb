# encoding: UTF-8
# coding: UTF-8
# -*- coding: UTF-8 -*-
#
require_relative '../spec_helper'

describe 'skeleton::default' do
  subject { ChefSpec::Runner.new.converge(described_recipe) }

  # Write full examples using the `expect` syntax
  it 'does includes recipes' do
    expect(subject).to include_recipe('apt')
  end
end
