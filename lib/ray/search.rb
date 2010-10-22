# encoding: utf-8

module Search

  def self.extension query, source = :registry, cache = true
    if cache
      begin
        search_cache = YAML.load_file "#{ENV['HOME']}/.ray/search.cache"
        hits = []
        search_cache.each { |extension|
          hits << extension if extension[:name].include? query
        }
        if hits.any?
          hits << { :cached_search => true }
          return hits
        end
      rescue
        FileUtils.mkdir_p "#{ENV['HOME']}/.ray"
        FileUtils.touch "#{ENV['HOME']}/.ray/search.cache"
      end
    end

    case source
    when :registry
      response = ''
      open("http://ext.radiantcms.org/extensions.xml").each_line { |line| response << line }
      xml = REXML::Document.new(response)
      results = []
      xml.elements.each('extensions/extension') { |el|
        if el.elements['name'].text =~ /#{query}/
          results << el
        end
      }
      results.normalize.cache
    when :github
      query.gsub! /\ /, '+'
      response = ''
      open("http://github.com/api/v2/yaml/repos/search/#{query}").each_line { |line| response << line }
      results = [YAML.load(response)].normalize
      results.cache
    when :rubygems
      query.gsub! /\ /, '+'
      response = open("http://rubygems.org/api/v1/search.json?query=#{query}").gets
      results = JSON.parse(response).normalize
      results.cache
    end
  end

  class ::Array
    def cache
      begin
        existing = YAML.load_file "#{ENV['HOME']}/.ray/search.cache"
      rescue
        FileUtils.mkdir_p "#{ENV['HOME']}/.ray"
        FileUtils.touch "#{ENV['HOME']}/.ray/search.cache"
        existing = []
      end
      existing = [] if existing == false
      File.open("#{ENV['HOME']}/.ray/search.cache", 'w') { |f|
        f.write YAML::dump(existing.concat(self).uniq)
      }
      self
    end

    def normalize
      results = []
      if self[0].class == REXML::Element # registry
        self.each { |r|
          result = {}
          result[:name] = r.elements['name'].text
          result[:description] = r.elements['description'].text
          result[:repository] = r.elements['repository-url'].text
          result[:url] = result[:repository].gsub /git(.*).git/, 'http\1'
          result[:download] = r.elements['download-url'].text
          result[:score] = 0.0
          results << result
        }
        return results
      elsif self[0]['repositories'] # github
        self[0]['repositories'].each { |r|
          result = {}
          result[:name] = r['name'].gsub /radiant-(.*)-extension/, '\1'
          result[:description] = r['description']
          result[:repository] = "git://github.com/#{r['username']}/#{r['name']}.git"
          result[:url] = result[:repository].gsub /git(.*).git/, 'http\1'
          result[:download] = "http://github.com/#{r['username']}/#{r['name']}/zipball/master"
          result[:score] = r['score']
          results << result
        }
        return results
      elsif self # rubygems
        self.each { |r|
          result = {}
          result[:name] = r['name'].gsub /radiant-(.*)-extension/, '\1'
          result[:description] = r['info']
          result[:repository] = r['source_code_uri'].gsub /http(.*)/, 'git\1.git'
          result[:url] = result[:repository].gsub /git(.*).git/, 'http\1'
          result[:download] = r['gem_uri']
          result[:score] = 0.0
          results << result
        }
        return results
      end
    end
  end

end
