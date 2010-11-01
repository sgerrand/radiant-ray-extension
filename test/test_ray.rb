# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray'

MiniTest::Unit.autorun

RAY_ROOT  = "test/mocks/.ray"

describe Ray do
  it 'is extended by Preferences' do
    Ray.must_respond_to 'preferences'
    Ray.must_respond_to 'preferences='
  end

  describe '#new' do
    before do
      @ray = Ray.new 'spec', ['a', 'b'], { :key => :value }
    end

    it 'returns @input' do
      @ray.input.wont_be_nil
    end
    it 'returns @preferences' do
      @ray.preferences.wont_be_nil
    end

    describe '@input' do
      it 'returns a Hash' do
        @ray.input.must_be_kind_of Hash
      end
      it 'contains :command' do
        @ray.input[:command].wont_be_nil
      end
      it 'contains :arguments' do
        @ray.input[:arguments].wont_be_nil
      end
      it 'contains :options' do
        @ray.input[:options].wont_be_nil
      end
      it 'contains :environment' do
        @ray.input[:environment].wont_be_nil
      end

      describe ':command' do
        it 'is a Symbol' do
          @ray.input[:command].must_be_kind_of Symbol
        end
      end

      describe ':arguments' do
        it 'is a Array' do
          @ray.input[:arguments].must_be_kind_of Array
        end
      end

      describe ':options' do
        it 'is a Hash' do
          @ray.input[:options].must_be_kind_of Hash
        end
      end

      describe ':environment' do
        it 'is a String' do
          @ray.input[:environment].must_be_kind_of String
        end
        it 'is last item in :arguments' do
          ray = Ray.new 'spec', ['a', 'test']
          ray.input[:environment].must_match 'test'
        end
        it 'is removed from :arguments' do
          ray = Ray.new 'spec', ['a', 'test']
          ray.input[:arguments].wont_include 'test'
        end
      end
    end

    describe '@preferences' do
      it 'is a Hash' do
        @ray.preferences.must_be_kind_of Hash
      end
      it 'is writable' do
        @ray.preferences = { :download => :http }
        @ray.preferences[:download].must_equal :http
      end
      it 'contains :download' do
        @ray.preferences[:download].wont_be_nil
      end
      it 'contains :restart' do
        @ray.preferences[:restart].wont_be_nil
      end
      it 'contains :sudo' do
        @ray.preferences[:sudo].wont_be_nil
      end
      it 'is extendable' do
        @ray.preferences = { :key => :value }
        @ray.preferences[:key].must_equal :value
      end

      describe ':download' do
        it 'is :git by default' do
          @ray.preferences[:download].must_equal :git
        end
      end

      describe ':restart' do
        it 'should be false by default' do
          @ray.preferences[:restart].must_equal false
        end
      end

      describe ':sudo' do
        it 'should be false by default' do
          @ray.preferences[:sudo].must_equal false
        end
      end
    end
  end
end
