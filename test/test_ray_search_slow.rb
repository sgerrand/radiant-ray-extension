# encoding: utf-8

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray/search'

MiniTest::Unit.autorun

RAY_ROOT_GLOBAL = 'test/mocks/ray'
CACHE           = "#{RAY_ROOT_GLOBAL}/search"

describe Search do
  describe '#live' do
    it 'returns an Array' do
      Search.live(:kramdown_filter).must_be_kind_of Array
    end
  end

  describe '#github' do
    it 'returns an Array' do
      Search.github(:kramdown_filter).must_be_kind_of Array
    end
  
    describe 'Github search result' do
      before do
        @s = Search.github(:kramdown_filter)[0]
      end
  
      it 'is a Hash' do
        @s.must_be_kind_of Hash
      end
      it 'has required extension information' do
        @s[:name].wont_be_nil
        @s[:description].wont_be_nil
        @s[:url].wont_be_nil
        @s[:repository].wont_be_nil
        @s[:score].wont_be_nil
        @s[:zip].wont_be_nil
      end
    end
  end

  describe '#registry' do
    it 'returns an Array' do
      Search.registry(:kramdown_filter).must_be_kind_of Array
    end
  
    describe 'Registry search result' do
      before do
        @s = Search.registry(:kramdown_filter).first
      end
  
      it 'is a Hash' do
        @s.must_be_kind_of Hash
      end
      it 'has required extension information' do
        @s[:name].wont_be_nil
        @s[:description].wont_be_nil
        @s[:url].wont_be_nil
        @s[:repository].wont_be_nil
        @s[:download].wont_be_nil
      end
      it 'filters search results' do
        r = Search.registry :kramdown
        r.first[:name].must_match('kramdown_filter')
        r.length.must_equal(1)
      end
    end
  end

  describe '#rubygems' do
    it 'returns an Array' do
      Search.rubygems(:kramdown_filter).must_be_kind_of Array
    end
  
    describe 'RubyGems search result' do
      before do
        @s = Search.rubygems(:kramdown_filter)[0]
      end
  
      it 'is a Hash' do
        @s.must_be_kind_of Hash
      end
      it 'has required extension information' do
        @s[:name].wont_be_nil
        @s[:description].wont_be_nil
        @s[:url].wont_be_nil
        @s[:repository].wont_be_nil
        @s[:gem].wont_be_nil
      end
      it 'filters search results' do
        r = Search.rubygems :kramdown
        r.first[:name].must_match('kramdown_filter')
        r.length.must_equal(1)
      end
    end
  end

  describe '#cache' do
    after do
      FileUtils.rm CACHE
    end

    it 'caches search results' do
      Search.all :kramdown
      File.read("#{CACHE}").must_match /---\ \n/
    end
    it 'appends new cache to old cache' do
      Search.registry :kramdown_filter
      Search.github :bluecloth2_filter
      Search.local('').length.must_equal 2
    end
    it 'merges similar cache items' do
      Search.registry :kramdown_filter
      Search.github :kramdown_filter
      Search.local('').length.must_equal 1
    end
  end
end
