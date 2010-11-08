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
  describe '#subjects' do
    it 'returns the subjects' do
      [:a].subjects.must_equal [:a]
      [:test].subjects.must_equal [:test]
      [:test, :a].subjects.must_equal [:test, :a]
      [:a, :development].subjects.must_equal [:a]
      [:a, :production].subjects.must_equal [:a]
      [:a, :test].subjects.must_equal [:a]
    end
  end

  describe '#environment' do
    it 'returns the environment' do
      [:a].environment.must_equal 'development'
      [:test].environment.must_equal 'development'
      [:test, :a].environment.must_equal 'development'
      [:a, :development].environment.must_equal 'development'
      [:a, :production].environment.must_equal 'production'
      [:a, :test].environment.must_equal 'test'
    end
  end

  describe '#has_environment?' do
    it 'checks arguments for environment' do
      [:a].has_environment?.must_be_nil
      [:test].has_environment?.must_be_nil
      [:test, :a].has_environment?.must_be_nil
      [:a, :development].has_environment?.must_equal true
      [:a, :production].has_environment?.must_equal true
      [:a, :test].has_environment?.must_equal true
    end
  end

  describe '#results' do
    after do
      FileUtils.rm CACHE
    end

    it 'is a String' do
      Search.all(:kramdown).results.must_be_kind_of String
    end
  end

  describe '#details' do
    after do
      FileUtils.rm CACHE
    end

    it 'is a String' do
      Search.all(:kramdown).details.must_be_kind_of String
    end
  end

  describe '#pick' do
    after do
      FileUtils.rm CACHE
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
