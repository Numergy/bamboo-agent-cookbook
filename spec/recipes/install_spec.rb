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
      expect { subject }.to raise_error(ArgumentError, /wrapper_conf_properties is not a Hash/)
    end
  end

  describe 'with parameters' do
    let(:subject) do
      ChefSpec::Runner.new do |node|
        node.set['bamboo-agent']['agents'] = {
          id: 1,
          capabilities: {},
          wrapper_conf_properties: 'string'
        }
      end.converge(described_recipe)
    end

    it 'should fail' do

    end
  end
end
