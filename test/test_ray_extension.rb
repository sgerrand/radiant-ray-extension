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
end
