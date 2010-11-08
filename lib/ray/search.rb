# encoding: utf-8

require 'fileutils'
require 'json'
require 'open-uri'
require 'rexml/document'
require 'yaml'

require 'ray/array'
require 'ray/hash'
require 'ray/string'

RAY_ROOT_GLOBAL = "#{ENV['HOME']}/.ray"
CACHE           = "#{RAY_ROOT_GLOBAL}/search"

module Search

  def self.all query
    cached_hits = File.exist?(CACHE) ? local(query) : []
    cached_hits.any? ? cached_hits : live(query)
  end

  def self.local query, hits = []
    cache = YAML.load_file CACHE
    cache.each { |entry|
      name_or_description = "#{entry[:name]} #{entry[:description]}"
      hits << entry if name_or_description.include? query.to_s
    } if cache
    return hits
  end

  def self.live query
    github_hits = github(query) || []
    return github_hits unless github_hits.empty?
    rubygems_hits = rubygems(query) || []
    return rubygems_hits unless rubygems_hits.empty?
    registry_hits = registry(query) || []
    return registry_hits unless registry_hits.empty?
    return []
  end

  def self.github query
    results = normalize( parse( url(query, :github) )['repositories'] )
    cache results
    return results
  end

  def self.registry query
    results = filtered( normalize( parse( url(query, :registry) ) ), query )
    cache results
    return results
  end

  def self.rubygems query
    results = filtered( normalize( parse( url(query, :rubygems) ) ), query )
    cache results
    return results
  end

  def self.cache results
    if results
      cache = File.exist?(CACHE) ? YAML.load_file(CACHE) : setup
      if cache
        duplicates = compare cache, results
        if duplicates[:new].any?
          # NOTE: we don't want to alter results
          _results = results.clone
          new_cache = merge duplicates, cache, _results
        else
          new_cache = cache + results
        end
      else
        new_cache = results
      end
      save new_cache
    end
  end

  def self.save new_cache
    File.open(CACHE, 'w') { |cache|
      cache.write new_cache.to_yaml
    }
  end

  def self.compare cache, results
    names = results.names
    duplicates = { :new => [], :old => [] }
    cache.each { |entry|
      name = entry[:name]
      if names.has_key? name
        duplicates[:new] << names[name]
        duplicates[:old] << cache.index(entry)
      end
    }
    return duplicates
  end

  def self.merge duplicates, cache, _results
    new_dups = duplicates[:new]
    old_dups = duplicates[:old]
    merges   = []
    old_dups.each { |dup|
      merges << cache[dup].merge(_results[new_dups[old_dups.index(dup)]])
    }
    new_dups.sort.reverse.each { |dup| _results.delete_at(dup) }
    old_dups.sort.reverse.each { |dup|    cache.delete_at(dup) }
    return merges + cache + _results
  end

  def self.url query, source = :github
    case source
    when :github
      open("http://github.com/api/v2/json/repos/search/radiant+#{query}").string
    when :registry
      open('http://ext.radiantcms.org/extensions.xml').read
    when :rubygems
      # NOTE: the - before query is a ridiculous hack
      #       the rubygems search api is not very extensive;
      #       for example: a search for "radiant settings"
      #       will not match any gems despite there being a
      #       perfectly good radiant-settings-extension gem.
      #       "solution": throw in a dash.
      open("http://rubygems.org/api/v1/search.json?query=-#{query}").gets
    end
  end

  def self.parse response
    if response.include? '<?xml'
      parse_registry response
    else
      parse_json response
    end
  end

  def self.parse_registry response, results = []
    REXML::Document.new(response).elements.each('extensions/extension') { |el|
      results << el
    }
    return results
  end

  def self.parse_json response
    JSON.parse response
  end

  def self.normalize results
    test = results[0] || {}
    if test.class == REXML::Element
      normalize_registry results
    elsif test['score']
      normalize_github results
    elsif test['gem_uri']
      normalize_rubygems results
    end
  end

  def self.normalize_github results, normalized_results = []
    results.each { |result|
      name = result['name']
      user = result['username']
      normalized_results << {
        :name         => normalize_extension_name(name),
        :description  => result['description'],
        :repository   => "git://github.com/#{user}/#{name}.git",
        :url          => result['record']['homepage'],
        :score        => result['score'],
        :zip          => "http://nodeload.github.com/#{user}/#{name}/zipball/master"
      }
    }
    return normalized_results
  end

  def self.normalize_registry results, normalized_results = []
    results.each { |result|
      this = result.elements
      repo = this['repository-url'].text || ''
      normalized_results << {
        :name         => normalize_extension_name(this['name'].text),
        :description  => this['description'].text,
        :repository   => repo,
        :url          => repo.gsub(/git(.*).git/, 'http\1'),
        :download     => this['download-url'].text
      }
    }
    return normalized_results
  end

  def self.normalize_rubygems results, normalized_results = []
    results.each { |result|
      normalized_results << {
        :name         => normalize_extension_name(result['name']),
        :description  => result['info'],
        :repository   => result['source_code_uri'],
        :url          => result['project_uri'],
        :gem          => result['gem_uri']
      }
    }
    return normalized_results
  end

  def self.normalize_extension_name name, normalized_name = ''
    normalized_name = name.downcase
    normalized_name.gsub!(/-/, '_')
    normalized_name.gsub!(/radiant_(.*)_extension/i, '\1')
    normalized_name.gsub!(/\bradiant_|_extension\b/i, '')
    return "radiant-#{normalized_name}-extension"
  end

  def self.filtered results, query, filtered_results = []
    results.each { |result|
      name_or_description = "#{result[:name]} #{result[:description]}"
      if name_or_description.include?(query.to_s) and name_or_description.include?('adiant')
        filtered_results << result 
      end
    } if results
    return filtered_results
  end

  def self.exact results, query
    matches = []
    results.each { |result|
      matches << result if result[:name].gsub(/radiant-(.*)-extension/, '\1') == query.to_s
    }
    return matches
  end

  def self.fuzzy results, query
    matches = []
    results.each { |result|
      matches << result if result[:name].gsub(/radiant-(.*)-extension/, '\1').include? query.to_s
    }
    return matches
  end

  def self.prompt_for_choice matches, query
    puts "!! More than one extension matched '#{query}'"
    puts '!! Please choose the extension you would like installed'
    show_options matches
    choice = user_choice
    return matches[choice - 1]
  end

  def self.show_options options
    options.each { |option|
      opt  = options.index(option) + 1
      name = option[:name].gsub(/radiant-(.*)-extension/, '\1')
      user = option[:repository].gsub(/git:\/\/github\.com\/(.*)\/.+\.git/, '\1')
      used = "   #{opt}. #{name} [#{user}] ".length
      puts "   #{opt}. #{name} [#{user}] #{option[:description][0...(69 - used)]}..."
    }
  end

  def self.user_choice
    print 'Extension number (c to cancel): '
    STDIN.gets.chomp.to_i
  end

  def self.setup
    FileUtils.mkdir_p RAY_ROOT_GLOBAL
    FileUtils.touch CACHE
    return []
  end
end
