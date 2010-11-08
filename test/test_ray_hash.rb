# encoding: utf-8

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray/search'
require 'ray/hash'

MiniTest::Unit.autorun

RAY_ROOT_GLOBAL = 'test/mocks/ray'
CACHE           = "#{RAY_ROOT_GLOBAL}/search"

describe Hash do
  describe '#extended' do
    after do
      FileUtils.rm CACHE
    end

    it 'is a String' do
      Search.all(:kramdown)[0].extended.must_be_kind_of String
    end
    it 'is in extended format' do
      Search.all(:kramdown)[0].extended.must_match /--\ kramdown_filter.*\n\ \ \ http/
    end
  end

  describe '#truncated' do
    after do
      FileUtils.rm CACHE
    end

    it 'is a String' do
      Search.all(:kramdown)[0].truncated.must_be_kind_of String
    end
    it 'is in truncated format' do
      Search.all(:kramdown)[0].truncated.must_match '** kramdown_filter: '
    end
  end
end