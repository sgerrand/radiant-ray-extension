# encoding: utf-8

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray/preferences'

MiniTest::Unit.autorun

RAY_ROOT        = 'test/mocks/ray'
RAY_ROOT_GLOBAL = 'test/mocks/ray'

describe Preferences do
  describe '#read' do
    it 'is a Hash' do
      Preferences.read.must_be_kind_of Hash
    end
    it 'reads preferences' do
      Preferences.read(:global).must_equal({ :download => :git })
      Preferences.read.must_equal({ :download => :git })
    end
  end

  describe '#write' do
    before do
      FileUtils.cp "#{RAY_ROOT_GLOBAL}/preferences", "#{RAY_ROOT_GLOBAL}/preferences-bak"
    end
    after do
      FileUtils.rm_f "#{RAY_ROOT_GLOBAL}/preferences"
      FileUtils.mv "#{RAY_ROOT_GLOBAL}/preferences-bak", "#{RAY_ROOT_GLOBAL}/preferences"
    end
    it 'is a Hash' do
      Preferences.write({}).must_be_kind_of Hash
    end
    it 'writes preferences' do
      Preferences.write({ :sudo => false })
      Preferences.read.must_equal({ :download => :git, :sudo => false })
      Preferences.write({ :submodule => true }, :global)
      Preferences.read(:global).must_equal({ :download => :git, :sudo => false, :submodule => true })
    end
    it 'merges new and old preferences' do
      Preferences.write({ :download => :http })
      Preferences.write({ :download => :http }, :global)
      Preferences.read.must_equal({ :download => :http })
      Preferences.read(:global).must_equal({ :download => :http })
    end
  end
end
