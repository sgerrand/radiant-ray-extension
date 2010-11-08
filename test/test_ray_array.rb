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
    it 'is a String' do
      Search.local(:kramdown).results.must_be_kind_of String
    end
  end

  describe '#details' do
    it 'is a String' do
      Search.local(:kramdown).details.must_be_kind_of String
    end
  end
end
