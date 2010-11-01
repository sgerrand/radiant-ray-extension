# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray'

MiniTest::Unit.autorun

RAY_ROOT = "test/mocks/.ray"

describe Search do
  it 'is a Module' do
    Search.must_be_kind_of Module
  end

  describe '#search_live' do
    it 'returns an Array' do
      Ray.search_live('kramdown_filter').must_be_kind_of Array
    end
  end

  describe '#search_registry' do
    it 'returns an Array' do
      Ray.search_registry('kramdown_filter').must_be_kind_of Array
    end
  end

  describe '#search_github' do
    it 'returns an Array' do
      Ray.search_github('kramdown_filter').must_be_kind_of Array
    end
  end

  describe '#search_rubygems' do
    it 'returns an Array' do
      Ray.search_rubygems('kramdown_filter').must_be_kind_of Array
    end
  end

  describe '#search' do
    it 'caches search results' do
      Ray.search 'kramdown_filter', :github
      File.read("#{RAY_ROOT}/search").must_match /---\ \n/
    end
    it 'appends new cache to old cache' do
      FileUtils.cp "#{RAY_ROOT}/search", "#{RAY_ROOT}/search-bak"
      FileUtils.rm "#{RAY_ROOT}/search"
      Ray.search_registry 'kramdown_filter'
      Ray.search_github 'bluecloth2_filter'
      Ray.search('').length.must_equal 2
      FileUtils.rm "#{RAY_ROOT}/search"
      FileUtils.mv "#{RAY_ROOT}/search-bak", "#{RAY_ROOT}/search"
    end
    it 'merges similar cache items' do
      FileUtils.cp "#{RAY_ROOT}/search", "#{RAY_ROOT}/search-bak"
      FileUtils.rm "#{RAY_ROOT}/search"
      Ray.search_registry 'kramdown_filter'
      Ray.search_github 'kramdown_filter'
      Ray.search('').length.must_equal 1
      FileUtils.rm "#{RAY_ROOT}/search"
      FileUtils.mv "#{RAY_ROOT}/search-bak", "#{RAY_ROOT}/search"
    end
  end

  describe Array do
    describe '#filter' do
      it 'filters search results' do
        results = Ray.search_rubygems 'kramdown'
        results.first[:name].must_match('kramdown_filter') &&
        results.length.must_equal(1)
      end
    end

    describe '#pick' do
      it 'raises exceptions when no matches are found' do
        proc { Ray.search('zzz').pick('kramdown') }.must_raise RuntimeError
      end
      it 'prompts the user for a choice when there is more than one exact match' do
        Ray.search('blog').pick('blog')[:repository].must_match 'git://github.com/'
      end
      it 'prompts the user for a choice when there is more than one fuzzy match' do
        Ray.search('paperclipped').pick('paperclipped_m')[:repository].must_match 'git://github.com/'
      end
    end
  end
end
