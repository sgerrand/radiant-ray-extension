# encoding: utf-8

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'ray/array'
require 'ray/preferences'
require 'ray/search'

RAY_ROOT        = "#{Dir.pwd}/.ray"
RAY_ROOT_GLOBAL = "#{ENV['HOME']}/.ray"

class Ray

  attr_accessor :command, :subjects, :options, :environment

  def initialize command = :add, arguments = [], options = {}
    @command     = command.to_sym
    @subjects    = arguments.subjects
    @options     = options
    @environment = arguments.environment
  end

end
