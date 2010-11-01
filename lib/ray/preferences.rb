# encoding: utf-8

require 'fileutils'
require 'yaml'

module Preferences

  def preferences scope = :local, file = nil
    prefs = preferences_file scope, file
    File.exist?(prefs) ? YAML.load_file(prefs) : {}
  end

  def preferences= arguments
    options = {
      :preferences => (arguments[:preferences] || {}),
      :scope => (arguments[:scope] || :local),
      :file => (arguments[:file] || nil)
    }
    prefs = preferences_file options[:scope], options[:file]
    File.open(prefs, 'w') { |this|
      this.write options[:preferences].to_s
    }
    return options[:preferences]
  end

  def preferences_file(scope = :local, file = nil)
    case
    when file    then return file
    when :global then "#{RAY_ROOT}/preferences"
    when :local  then './.ray/preferences'
    end
  end

  # Hash extensions
  class ::Hash
    def to_s
      YAML::dump self
    end
  end
end
