# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'ray/extension'
require 'ray/preferences'
require 'ray/search'

HOME      = ENV['HOME']
RAY_ROOT  = "#{HOME}/.ray"

class Ray

  attr_reader   :input
  attr_accessor :preferences

  extend Preferences
  include Extension
  include Search

  def initialize command = '', arguments = [], options = {}
    @input = {
      :command      => command.to_sym,
      :arguments    => arguments,
      :options      => options
    }

    last = arguments.last
    if last =~ /production|test/
      @input[:environment] = last
      @input[:arguments].pop
    else
      @input[:environment] = 'development'
    end

    @preferences = {
      :download => :git,
      :restart => false,
      :sudo => false
    }

    global = Ray.preferences :global
    local  = Ray.preferences

    @preferences.merge(global).merge local

  end

  def preferences= prefs
    @preferences = prefs
  end

end
