# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray'

MiniTest::Unit.autorun

describe Search do
  it 'is a Module' do
    Search.must_be_kind_of Module
  end

  describe '#extension' do
    it 'is an Array' do
      Search.extension('kramdown_filter').must_be_kind_of Array
    end

    describe 'search result' do
      before do
        @result = Search.extension('kramdown_filter')[0]
      end

      it 'is a Hash' do
        @result.must_be_kind_of Hash
      end
      it 'contains :name' do
        @result[:name].wont_be_nil
      end
      it 'contains :description' do
        @result[:description].wont_be_nil
      end
      it 'contains :url' do
        @result[:url].wont_be_nil
      end
      it 'contains :repository' do
        @result[:repository].wont_be_nil
      end
      it 'contains :download' do
        @result[:download].wont_be_nil
      end
      it 'contains :score' do
        @result[:score].wont_be_nil
      end
    end

    it 'searches the cache first' do
      results = Search.extension 'kramdown_filter'
      results.last[:cached_search].must_equal true
    end

    # NOTE: the next three tests do not run by default
    #       because they make network requests. if you
    #       want to run them uncomment `, nil`
    describe 'Extension Registry search' do
      it 'normalizes results to cachable format' do
        results = Search.extension 'kramdown_filter', :registry#, nil
        results[0][:name].must_match 'kramdown_filter'
      end
    end

    describe 'Github search' do
      it 'normalizes results to cachable format' do
        results = Search.extension 'kramdown_filter', :github#, nil
        results[0][:name].must_match 'kramdown_filter'
      end
    end

    describe 'Rubygems search' do
      it 'normalizes results to cachable format' do
        results = Search.extension 'kramdown_filter', :rubygems#, nil
        results[0][:name].must_match 'kramdown_filter'
      end
    end
  end

  describe 'Array extensions' do
    describe '#cache' do
      it 'caches search results' do
        Extension.search 'kramdown_filter', :registry
        File.read("#{ENV['HOME']}/.ray/search.cache").must_match '--- '
      end
    end
  end
end
