# encoding: utf-8

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'minitest/spec'
require 'ray/string'

MiniTest::Unit.autorun

describe String do
  describe '#wrap' do
    it 'wraps texts at 80 columns' do
      ('a' * 81).wrap.must_match /a{80}\na\n/
      ('a' * 3).wrap(1).must_match /a\na\na\n/
    end
    it 'pads text' do
      ('a' * 3).wrap(3, 3).must_match /\ \ \ aaa\n/
    end
  end
end
