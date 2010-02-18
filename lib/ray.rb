# friendly extension management for Radiant CMS
class Ray

  require 'yaml'
  require 'fileutils'
  require 'ray/preferences'
  require 'ray/help'
  require 'ray/enable'
  require 'ray/disable'
  require 'ray/install'

  begin
    require 'launchy'
  rescue LoadError
    require 'rubygems'
    require 'launchy'
  end

  def initialize options
    @action = options.first
    @error = validate_action
    options.shift
    @options = options
  end

  attr_reader :action, :error, :options

  def validate_action
    @action.match(/\benable|disable|help|install|setup\b/) ? '' : error_message("is not a valid command.")
  end

  def error_message message
    "'#{@action}' #{message}\nRun 'ray help' for usage information."
  end

end
