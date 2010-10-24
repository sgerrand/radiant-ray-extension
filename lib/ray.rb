# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'json'
require 'fileutils'
require 'open-uri'
require 'rexml/document'
require 'yaml'
require 'ray/extension'
require 'ray/preferences'
require 'ray/search'

HOME      = ENV['HOME']
RAY_ROOT  = "#{HOME}/.ray"

class Ray

  attr_reader   :input
  attr_accessor :preferences

  include Extension
  include Preferences
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

    global = Preferences.open :global
    local = Preferences.open :local

    @preferences.merge(global).merge local

  end

  def preferences= prefs
    @preferences = Preferences.save prefs
  end

end
