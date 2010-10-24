# encoding: utf-8

require 'json'
require 'open-uri'
require 'rexml/document'
require 'yaml'

module Search

  def self.cache query
    hits = []
    begin
      cache = YAML.load_file "#{RAY_ROOT}/search.cache" || []
      cache.each { |extension|
        hits << extension if extension[:name].include? query
      } if cache.any?
    rescue
      hits = Search.all query
    end
    return hits
  end

  def self.all query
    results = [
      Search.registry(query),
      Search.github(query),
      Search.rubygems(query)
    ]
    return results.flatten
  end

  def self.registry query
    results = []
    response = ''
    open("http://ext.radiantcms.org/extensions.xml").each_line { |line|
      response << line
    }
    REXML::Document.new(response).elements.each('extensions/extension') { |el|
      if el.elements['name'].text =~ /#{query}/
        results << el
      end
    }
    return results.normalize_registry_results.cache
  end
  
  def self.github query
    response = ''
    open("http://github.com/api/v2/yaml/repos/search/#{query}").each_line { |line|
      response << line
    }
    results = [YAML.load(response)].normalize_github_results
    results.cache
    return results
  end
  
  def self.rubygems query
    response = open("http://rubygems.org/api/v1/search.json?query=#{query}").gets
    results = JSON.parse(response).normalize_rubygems_results
    results.cache
    return results
  end

  # Array extensions
  class ::Array
    def cache
      unless has_cache?
        FileUtils.touch "#{RAY_ROOT}/search.cache"
      end
      File.open("#{RAY_ROOT}/search.cache", 'w') { |file|
        file.write YAML::dump(old_cache.concat(self).uniq)
      }
      return self
    end

    def has_cache?
      File.exist? "#{RAY_ROOT}/search.cache"
    end

    def old_cache
      YAML.load_file("#{RAY_ROOT}/search.cache") || []
    end

    def normalize_registry_results
      results = []
      self.each { |this|
        this = this.elements
        repo = this['repository-url'].text
        results << result = {
                              :description  => this['description'].text,
                              :repository   => repo,
                              :download     => this['download-url'].text,
                              :score        => 0.0,
                              :name         => this['name'].text,
                              :url          => repo.gsub(/git(.*).git/, 'http\1')
                            }
      }
      return results
    end

    def normalize_github_results
      results = []
      self[0]['repositories'].each { |this|
        name = this['name']
        user = this['username']
        results << result = {
                              :description => this['description'],
                              :repository  => "git://github.com/#{user}/#{name}.git",
                              :download    => "http://github.com/#{user}/#{name}/zipball/master",
                              :score       => this['score'],
                              :name        => name.gsub(/radiant-(.*)-extension/, '\1'),
                              :url         => this['record'].ivars['attributes']['homepage']
                            }
      }
      return results
    end

    def normalize_rubygems_results
      results = []
      self.each { |this|
        results << result = {
                              :description => this['info'],
                              :repository  => this['source_code_uri'],
                              :download    => this['gem_uri'],
                              :score       => 0.0,
                              :name        => this['name'].gsub(/radiant-(.*)-extension/, '\1'),
                              :url         => this['project_uri']
                            }
      }
      return results
    end

    def results
      results = ''
      self.each { |result|
        results << result.truncated
      }
      return results
    end

    def details
      results = ''
      self.each { |result|
        results << result.extended
      }
      return results
    end
  end

  # Hash extensions
  class ::Hash
    def extended
      name = self[:name]
      len = name.length
"-- #{name} #{'-' * (68 - len)}
   #{(self[:url])[0...69]}

   #{(self[:description]).wrap}

   GIT: ray add #{name}
        ray add #{name} --submodule
   GEM: ray add #{name} --gem
        ray add #{name} --gem --sudo
   ZIP: ray add #{name} --zip
\n"
    end
    def truncated
      name = self[:name]
      "** #{name}: #{(self[:description])[0...((72 - name.length) - 8)]}...
   Install: ray add #{name}
   Details: ray info #{name}
\n"
    end
  end

  # String extensions
  class ::String
    def wrap
      col = 69
      self.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "   \\1\\3\n")
    end
  end

end
