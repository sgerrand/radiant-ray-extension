# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray'
require 'ray/preferences'

MiniTest::Unit.autorun

RAY_ROOT = 'test/mocks/.ray'

describe Preferences do
  before do
    @prefs = { :download => :git, :restart => false, :sudo => false }
  end

  it 'is a Module' do
    Preferences.must_be_kind_of Module
  end

  describe '#preferences_file' do
    it 'returns a String' do
      Ray.preferences_file.must_be_kind_of String
    end
    it 'returns the path to the global preferences' do
      Ray.preferences_file(:global).must_match "#{RAY_ROOT}/preferences"
    end
    it 'returns the path to the local preferences' do
      Ray.preferences_file(:local).must_match "#{RAY_ROOT}/preferences"
    end
    it 'returns the path to arbitrary preferences' do
      Ray.preferences_file(:local, "/some/other/path").must_match '/some/other/path'
    end
  end

  describe '#preferences' do
    it 'returns a Hash' do
      Ray.preferences(:local, "#{RAY_ROOT}/preferences").must_be_kind_of Hash
    end
    it 'returns global preferences' do
      prefs = Ray.preferences :global, "#{RAY_ROOT}/ray_global_preferences"
      prefs.must_equal({ :sudo => false })
    end
    it 'returns local preferences' do
      prefs = Ray.preferences :local, "#{RAY_ROOT}/ray_local_preferences"
      prefs.must_equal({ :download => :git, :restart => false, :sudo => false })
    end
  end

  describe '#preferences=' do
    before do
      @rand = (rand * 10000000).to_i
      FileUtils.cp "#{RAY_ROOT}/preferences", "#{RAY_ROOT}/preferences-#{@rand}"
      FileUtils.cp "#{RAY_ROOT}/ray_local_preferences", "#{RAY_ROOT}/ray_local_preferences-#{@rand}"
      FileUtils.cp "#{RAY_ROOT}/ray_global_preferences", "#{RAY_ROOT}/ray_global_preferences-#{@rand}"
    end
    after do
      FileUtils.rm_f "#{RAY_ROOT}/preferences-#{@rand}"
      FileUtils.rm_f "#{RAY_ROOT}/ray_local_preferences-#{@rand}"
      FileUtils.rm_f "#{RAY_ROOT}/ray_global_preferences-#{@rand}"
    end

    it 'returns a Hash' do
      prefs = Ray.preferences = {
                :preferences  => { :download => :http },
                :scope        => :local,
                :file         => "#{RAY_ROOT}/preferences-#{@rand}"
              }
      prefs.must_be_kind_of Hash
    end
    it 'writes global preferences' do
      Ray.preferences = { :preferences => @prefs, :scope => :global, :file => "#{RAY_ROOT}/ray_global_preferences-#{@rand}" }
      Ray.preferences(:global, "#{RAY_ROOT}/ray_global_preferences-#{@rand}").must_equal @prefs
    end
    it 'writes local preferences' do
      Ray.preferences = { :preferences => @prefs, :file => "#{RAY_ROOT}/ray_local_preferences-#{@rand}" }
      Ray.preferences(:local, "#{RAY_ROOT}/ray_local_preferences-#{@rand}").must_equal @prefs
    end
    it 'merges new preferences with old preferences' do
      Ray.preferences = {
        :preferences => { :restart => :thin },
        :file => "#{RAY_ROOT}/ray_local_preferences-#{@rand}"
      }
      Ray.preferences = {
        :preferences => { :download => :http },
        :file => "#{RAY_ROOT}/ray_local_preferences-#{@rand}"
      }
      Ray.preferences(:local, "#{RAY_ROOT}/ray_local_preferences-#{@rand}").must_equal({ :restart => :thin, :download => :http, :sudo => false })
    end
  end

  describe Hash do
    describe '#to_s' do
      it 'returns a String' do
        @prefs.to_s.must_be_kind_of String
      end
    end
  end
end
