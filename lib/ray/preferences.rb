# encoding: utf-8

require 'fileutils'
require 'yaml'

RAY_ROOT        = "#{Dir.pwd}/.ray"
RAY_ROOT_GLOBAL = "#{ENV['HOME']}/.ray"

module Preferences

  def self.read scope = :local
    File.exist?(preference_file_for scope) ? load(scope) : {}
  end

  def self.write new_preferences, scope = :local
    setup(scope) unless File.exist?(preference_file_for scope)
    save(new_preferences, scope)
  end

  def self.preference_file_for scope
    case scope
    when :global
      "#{RAY_ROOT_GLOBAL}/preferences"
    else
      "#{RAY_ROOT}/preferences"
    end
  end

  def self.load scope
    YAML.load_file(preference_file_for scope)
  end

  def self.save new_preferences, scope
    old_preferences = load scope || {}
    preferences = old_preferences.merge(new_preferences)
    File.open(preference_file_for(scope), 'w') { |preferences_file|
      preferences_file.write preferences.to_yaml
    }
    return preferences
  end

  def self.setup scope
    scope == :global ? dir = RAY_ROOT_GLOBAL : RAY_ROOT
    FileUtils.mkdir "#{dir}"
    FileUtils.touch "#{dir}/preferences"
  end

end
