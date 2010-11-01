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
    merged = merge_preferences prefs, options[:preferences]
    File.open(prefs, 'w') { |this|
      this.write merged.to_s
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

  def merge_preferences old_prefs, new_prefs
    File.exist?(old_prefs) ? old = YAML.load_file(old_prefs) : {}
    old.merge new_prefs
  end

  # Hash extensions
  class ::Hash
    def to_s
      YAML::dump self
    end
  end
end
