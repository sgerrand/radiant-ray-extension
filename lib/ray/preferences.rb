# encoding: utf-8

require 'fileutils'
require 'yaml'

module Preferences

  def self.open scope = :local, file = nil
    pref_file = preference_file(scope, file)
    File.exist?("#{pref_file}") ? YAML.load_file("#{pref_file}") : {}
  end

  def self.save preferences, scope = :local, file = nil
    pref_file = preference_file(scope, file)
    File.open(pref_file, 'w') { |file| file.write preferences.to_s }
    Preferences.open scope, pref_file
  end

  def self.preference_file scope, file
    case
    when file
      file
    when :global
      "#{HOME}/.ray/preferences"
    when :local
      "#{Dir.pwd}/.ray/preferences"
    end
  end

  # Hash extensions
  class ::Hash
    def to_s
      YAML::dump self
    end
  end
end
