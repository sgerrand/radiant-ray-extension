# encoding: utf-8

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray'

MiniTest::Unit.autorun

describe Ray do
  before do
    @r = Ray.new
  end

  describe '#new' do
    describe '@command' do
      it 'will exist' do
        @r.command.wont_be_nil
      end
      it 'is a Symbol' do
        @r.command.must_be_kind_of Symbol
        Ray.new('add').command.must_be_kind_of Symbol
      end
    end

    describe '@subjects' do
      it 'will exist' do
        @r.subjects.wont_be_nil
      end
      it 'is an Array' do
        @r.subjects.must_be_kind_of Array
      end
    end

    describe '@options' do
      it 'will exist' do
        @r.options.wont_be_nil
      end
      it 'is a Symbol' do
        @r.options.must_be_kind_of Hash
      end
    end

    describe '@environment' do
      it 'will exist' do
        @r.environment.wont_be_nil
      end
      it 'is a String' do
        @r.environment.must_be_kind_of String
        Ray.new(:test, [:extension, :production]).environment.must_be_kind_of String
      end
    end
  end
end
