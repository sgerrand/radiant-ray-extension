# encoding: utf-8

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray/search'
require 'ray/array'

MiniTest::Unit.autorun

RAY_ROOT_GLOBAL = 'test/mocks/ray'
CACHE           = "#{RAY_ROOT_GLOBAL}/search"

describe Array do
  describe '#pick' do
    before do
      FileUtils.cp CACHE, "#{RAY_ROOT_GLOBAL}/search-bak"
    end
    after do
      FileUtils.rm CACHE
      FileUtils.mv "#{RAY_ROOT_GLOBAL}/search-bak", CACHE
    end

    it 'is a Hash' do
      Search.all(:kramdown).pick('kramdown').must_be_kind_of Hash
    end
    it 'picks an exact match' do
      Search.all(:kramdown_filter).pick('kramdown_filter')[:name].must_match 'kramdown_filter'
    end
    it 'picks a close match when there is only one choice' do
      Search.all(:kramdown_filter).pick('kramdown')[:name].must_match 'kramdown_filter'
    end
    it 'picks an exact match from many' do
      Search.all(:paperclipped).pick('paperclipped_player')[:repository].must_match 'git://github.com/spanner/radiant-paperclipped_player-extension.git'
    end
    it 'raises exceptions when no matches are found' do
      proc { Search.all(:kramdown).pick('zzz') }.must_raise RuntimeError
    end
    it 'raises exceptions when no matches are found' do
      proc { Search.all(:zzz).pick('kramdown') }.must_raise RuntimeError
    end
    it 'prompts the user for a choice when there is more than one exact match' do
      Search.all(:blog).pick('blog')[:repository].must_match 'git://github.com/'
    end
    it 'prompts the user for a choice when there is more than one fuzzy match' do
      Search.all(:paperclipped).pick('paperclipped_m')[:repository].must_match 'git://github.com/'
    end
  end
end
