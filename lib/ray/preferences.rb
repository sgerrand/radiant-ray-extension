# encoding: utf-8

module Preferences

  def self.open scope = :local, file = nil
    pref_file = preference_file(scope, file)
    File.exist?("#{pref_file}") ? YAML.load_file("#{pref_file}") : {}
  end

  def self.save preferences, scope = :local, file = nil
    pref_file = preference_file(scope, file)
    File.open(pref_file, 'w') { |f| f.write preferences.to_s }
    Preferences.open scope, pref_file
  end

  class ::Hash
    def to_s
      YAML::dump self
    end
  end

  def self.preference_file scope, file
    case
    when file
      file
    when :global
      "#{ENV['HOME']}/.ray/preferences"
    when :local
      "#{Dir.pwd}/.ray/preferences"
    end
  end
end
