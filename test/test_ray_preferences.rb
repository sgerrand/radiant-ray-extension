# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray/preferences'

HOME = RAY_ROOT = "#{Dir.pwd}/test/mocks"

MiniTest::Unit.autorun

describe Preferences do
  before do
    @prefs = { :download => :git, :restart => false, :sudo => false }
  end

  it 'is a Module' do
    Preferences.must_be_kind_of Module
  end

  describe '#open' do
    it 'is a Hash' do
      Preferences.open.must_be_kind_of Hash
    end
    it 'reads global preferences' do
      prefs = Preferences.open :global, "#{RAY_ROOT}/ray_global_preferences"
      prefs.must_equal({ :sudo => false })
    end
    it 'reads local preferences' do
      prefs = Preferences.open :local, "#{RAY_ROOT}/ray_local_preferences"
      prefs.must_equal({ :download => :git, :sudo => true })
    end
  end

  describe '#save' do
    before do
      # randomize so tests may be run in parallel
      @rand = (rand * 10000000).to_i
      FileUtils.cp "#{RAY_ROOT}/ray_local_preferences", "#{RAY_ROOT}/ray_local_preferences-#{@rand}"
      FileUtils.cp "#{RAY_ROOT}/ray_global_preferences", "#{RAY_ROOT}/ray_global_preferences-#{@rand}"
    end
    after do
      FileUtils.rm "#{RAY_ROOT}/ray_local_preferences-#{@rand}"
      FileUtils.rm "#{RAY_ROOT}/ray_global_preferences-#{@rand}"
    end

    it 'is a Hash' do
      Preferences.save({}, :local, "#{RAY_ROOT}/ray_local_preferences-#{@rand}").must_be_kind_of Hash
    end
    it 'writes global preferences' do
      prefs = Preferences.save @prefs, :global, "#{RAY_ROOT}/ray_global_preferences-#{@rand}"
      real = Preferences.open :global, "#{RAY_ROOT}/ray_global_preferences-#{@rand}"
      real.must_equal @prefs
    end
    it 'writes local preferences' do
      prefs = Preferences.save @prefs, :local, "#{RAY_ROOT}/ray_local_preferences-#{@rand}"
      real = Preferences.open :local, "#{RAY_ROOT}/ray_local_preferences-#{@rand}"
      real.must_equal @prefs
    end
  end

  describe 'Hash extensions' do
    describe '#to_s' do
      it 'is a String' do
        @prefs.to_s.must_be_kind_of String
      end
    end
  end
end
