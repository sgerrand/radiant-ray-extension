# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'fileutils'
require 'ray/search'

MiniTest::Unit.autorun

RAY_ROOT = "test/mocks/.ray"

describe Search do
  after do
    FileUtils.rm_f "#{RAY_ROOT}/search.cache"
  end

  describe '#live' do
    it 'is an Array' do
      Search.live('kramdown_filter').must_be_kind_of Array
    end
  end

  describe '#registry' do
    it 'is an Array' do
      Search.registry('kramdown_filter').must_be_kind_of Array
    end
  end

  describe '#github' do
    it 'is an Array' do
      Search.github('kramdown_filter').must_be_kind_of Array
    end
  end

  describe '#rubygems' do
    it 'is an Array' do
      Search.rubygems('kramdown_filter').must_be_kind_of Array
    end
  end

  describe Array do
    describe '#all' do
      it 'caches search results' do
        Search.github 'kramdown_filter'
        File.read("#{RAY_ROOT}/search.cache").must_match /---\ \n/
      end
      it 'appends new cache to old cache' do
        Search.registry 'kramdown_filter'
        Search.github 'bluecloth2_filter'
        Search.all('').length.must_equal 2
      end
      it 'merges similar cache items' do
        Search.registry 'kramdown_filter'
        Search.github 'kramdown_filter'
        Search.all('').length.must_equal 1
      end
    end

    describe '#filter' do
      it 'filters search results' do
        results = Search.github 'kramdown'
        results.first[:name].must_match('kramdown_filter') &&
        results.length.must_equal(1)
      end
    end

    describe '#pick' do
      it 'is a Hash' do
        Search.all('kramdown').pick('kramdown_filter').must_be_kind_of Hash
      end
      it 'raises exceptions when no matches are found' do
        proc { Search.all('zzz').pick('kramdown') }.must_raise RuntimeError
      end
      it 'prompts the user for a choice when there is more than one exact match' do
        Search.all('blog').pick('blog')[:repository].must_match 'git://github.com/'
      end
      it 'prompts the user for a choice when there is more than one fuzzy match' do
        Search.all('paperclipped').pick('paperclipped')[:repository].must_match 'git://github.com/'
      end
    end
  end
end
