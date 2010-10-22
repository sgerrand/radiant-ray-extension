# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray'

MiniTest::Unit.autorun

describe Extension do
  it 'is a Module' do
    Extension.must_be_kind_of Module
  end

  describe '#search' do
    it 'is an Array' do
      Extension.search('kramdown_filter').must_be_kind_of Array
    end

    describe 'search result' do
      before do
        @search = Extension.search('kramdown_filter')[0]
      end

      it 'is a Hash' do
        @search.must_be_kind_of Hash
      end
      it 'contains :name' do
        @search[:name].wont_be_nil
      end
      it 'contains :description' do
        @search[:description].wont_be_nil
      end
      it 'contains :url' do
        @search[:url].wont_be_nil
      end
      it 'contains :repository' do
        @search[:repository].wont_be_nil
      end
      it 'contains :download' do
        @search[:download].wont_be_nil
      end
      it 'contains :score' do
        @search[:score].wont_be_nil
      end
    end

    it 'searches the cache first' do
      search = Extension.search 'kramdown_filter'
      search.last[:cached_search].must_equal true
    end

    # NOTE: the next three tests do not run by default
    #       because they make network requests. if you
    #       want to run them uncomment `, nil`
    describe 'Extension Registry search' do
      it 'normalizes results to cachable format' do
        search = Extension.search 'kramdown_filter', :registry#, nil
        search[0][:name].must_match 'kramdown_filter'
      end
    end

    describe 'Github search' do
      it 'normalizes results to cachable format' do
        search = Extension.search 'kramdown_filter', :github#, nil
        search[0][:name].must_match 'kramdown_filter'
      end
    end

    describe 'Rubygems search' do
      it 'normalizes results to cachable format' do
        search = Extension.search 'kramdown_filter', :rubygems#, nil
        search[0][:name].must_match 'kramdown_filter'
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
