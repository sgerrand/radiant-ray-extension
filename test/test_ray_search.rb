# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray/search'

MiniTest::Unit.autorun

RAY_ROOT = "test/mocks"

describe Search do
  it 'is a Module' do
    Search.must_be_kind_of Module
  end

  describe '#all' do
    it 'is an Array' do
      Search.all('kramdown_filter').must_be_kind_of Array
    end
  end

  describe 'search result' do
    before do
      @result = Search.all('kramdown_filter')[0]
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
    it 'contains :score' do
      @result[:score].wont_be_nil
    end
  end

  describe Array do
    describe '#results' do
      it 'is a String' do
        Search.all('kramdown_filter').results.must_be_kind_of String
      end
    end

    describe '#details' do
      it 'is a String' do
        Search.all('kramdown_filter').details.must_be_kind_of String
      end
    end
  end

  describe Hash do
    describe '#extended' do
      it 'is a String' do
        Search.all('kramdown_filter')[0].extended.must_be_kind_of String
      end
      it 'is in extended format' do
        Search.all('kramdown_filter')[0].extended.must_match /--\ kramdown_filter.*\n\ \ \ http/
      end
    end

    describe '#truncated' do
      it 'is a String' do
        Search.all('kramdown_filter')[0].truncated.must_be_kind_of String
      end
      it 'is in truncated format' do
        Search.all('kramdown_filter')[0].truncated.must_match '** kramdown_filter: '
      end
    end
  end

  describe String do
    describe '#wrap' do
      it 'is a String' do
        'wrap'.wrap.must_be_kind_of String
      end
      it 'indents by three spaces' do
        'indented'.wrap.must_match '   indented'
      end
      it 'wraps at seventy-two columns' do
        ('a' * 80).wrap.must_match /\ \ \ .{69}\n/
      end
    end
  end
end
