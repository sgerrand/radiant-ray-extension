# encoding: utf-8
# see test_ray_search_slow for more tests

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray/search'

MiniTest::Unit.autorun

RAY_ROOT_GLOBAL = 'test/mocks/ray'
CACHE           = "#{RAY_ROOT_GLOBAL}/search"

describe Search do
  before do
    FileUtils.touch CACHE
  end

  describe '#all' do
    it 'returns an Array' do
      Search.local(:kramdown_filter).must_be_kind_of Array
    end
  end

  describe 'search result' do
    before do
      @s = Search.local(:kramdown_filter)[0]
    end
  
    it 'is a Hash' do
      @s.must_be_kind_of Hash
    end
    it 'has required extension information' do
      @s[:name].wont_be_nil
      @s[:description].wont_be_nil
      @s[:url].wont_be_nil
      @s[:repository].wont_be_nil
    end
  end
end
