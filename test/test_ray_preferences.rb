# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'fileutils'
require 'ray'

MiniTest::Unit.autorun

describe Preferences do
  before do
    @ray = Ray.new 'spec'
    @path = 'test/mocks'
  end

  it 'is a Module' do
    Preferences.must_be_kind_of Module
  end

  describe '#open' do
    it 'is a Hash' do
      Preferences.open.must_be_kind_of Hash
    end
    it 'reads global preferences' do
      prefs = Preferences.open :global, "#{@path}/ray_global_preferences"
      prefs.must_equal({ :sudo => false })
    end
    it 'reads local preferences' do
      prefs = Preferences.open :local, "#{@path}/ray_local_preferences"
      prefs.must_equal({ :download => :git, :sudo => true })
    end
  end

  describe '#save' do
    before do
      # randomize so tests can be run in parallel
      @rand = (rand * 10000000).to_i
      FileUtils.cp "#{@path}/ray_local_preferences", "#{@path}/ray_local_preferences-#{@rand}"
      FileUtils.cp "#{@path}/ray_global_preferences", "#{@path}/ray_global_preferences-#{@rand}"
    end
    after do
      FileUtils.rm "#{@path}/ray_local_preferences-#{@rand}"
      FileUtils.rm "#{@path}/ray_global_preferences-#{@rand}"
    end

    it 'is a Hash' do
      Preferences.save({}, :local, "#{@path}/ray_local_preferences-#{@rand}").must_be_kind_of Hash
    end
    it 'writes global preferences' do
      prefs = Preferences.save @ray.preferences, :global, "#{@path}/ray_global_preferences-#{@rand}"
      real = Preferences.open :global, "#{@path}/ray_global_preferences-#{@rand}"
      real.must_equal @ray.preferences
    end
    it 'writes local preferences' do
      prefs = Preferences.save @ray.preferences, :local, "#{@path}/ray_local_preferences-#{@rand}"
      real = Preferences.open :local, "#{@path}/ray_local_preferences-#{@rand}"
      real.must_equal @ray.preferences
    end
  end

  describe 'Hash extensions' do
    describe '#to_s' do
      it 'is a String' do
        @ray.preferences.to_s.must_be_kind_of String
      end
    end
  end
end
