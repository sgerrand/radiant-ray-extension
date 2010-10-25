# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray/search'

MiniTest::Unit.autorun

RAY_ROOT = "#{Dir.pwd}/test/mocks/.ray"

describe Search do
  describe '#all' do
    it 'is an Array' do
      Search.all('kramdown_filter').must_be_kind_of Array
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
    describe '#cache' do
      it 'caches search results' do
        FileUtils.rm_f "#{RAY_ROOT}/search.cache"
        Search.rubygems 'kramdown_filter'
        File.read("#{RAY_ROOT}/search.cache").must_match /---\ \n/
      end
    end

    describe '#filter' do
      it 'filters search results' do
        results = Search.github 'kramdown'
        results.first[:name].must_match('kramdown_filter') &&
        results.length.must_equal(1)
      end
    end
  end
end
