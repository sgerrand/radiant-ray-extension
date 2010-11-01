# encoding: utf-8

module Search

  def search query, source = :all
    case source
    when :all       then search_all query
    when :github    then search_github query
    when :registry  then search_registry query
    when :rubygems  then search_rubygems query
    when :live      then search_live query
    end
  end

  def search_all query
    search_cache query
  end

  def search_live query
    [
      search_github(query),
      search_registry(query),
      search_rubygems(query)
    ].flatten
  end

  def search_github query
    response = ''
    open("http://github.com/api/v2/yaml/repos/search/radiant+#{query}").each_line { |line|
      response << line
    }
    cache [YAML.load(response)].normalize_github_results
    [YAML.load(response)].normalize_github_results
  end

  def search_registry query
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
    cache results.normalize_registry_results
    results.normalize_registry_results
  end

  def search_rubygems query
    response = open("http://rubygems.org/api/v1/search.json?query=#{query}").gets
    cache JSON.parse(response).normalize_rubygems_results.filter
    JSON.parse(response).normalize_rubygems_results.filter
  end

  def search_cache query
    hits = []
    begin
      cache = YAML.load_file "#{RAY_ROOT}/search" || []
      cache.each { |extension|
        hits << extension if extension[:name].include? query
      } if cache.any?
    rescue; end
    if hits.any?
      hits
    else
      search_live query
    end
  end

  def cache results
    unless has_cache?
      FileUtils.touch "#{RAY_ROOT}/search"
    end
    if results.any?
      new_cache = merge_caches old_cache, results
      File.open("#{RAY_ROOT}/search", 'w') { |file|
        file.write YAML::dump(new_cache)
      }
    end
  end

  def has_cache?
    File.exist? "#{RAY_ROOT}/search"
  end

  def old_cache
    YAML.load_file("#{RAY_ROOT}/search") || []
  end

  def merge_caches old_cache, new_cache
    merged = []
    oc_rm = []
    nc_rm = []
    new_cache.each { |this|
      old_cache.each { |that|
        if this[:name] == that[:name]
          merged << that.merge(this)
          oc_rm << old_cache.index(that)
          nc_rm << new_cache.index(this)
        end
      }
    }
    oc_rm.uniq.sort.reverse.each { |index|
      old_cache.delete old_cache[index]
    }
    nc_rm.uniq.sort.reverse.each { |index|
      new_cache.delete new_cache[index]
    }
    old_cache.concat(new_cache).concat merged
  end

  # Array extensions
  class ::Array
    def normalize_registry_results
      results = []
      self.each { |this|
        this = this.elements
        repo = this['repository-url'].text || ''
        results << result = {
                              :description  => this['description'].text,
                              :repository   => repo,
                              :download     => this['download-url'].text,
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
        url  = this['record'].ivars['attributes']['homepage']
        url  = "http://github.com/#{user}/#{name}" if url == ''
        results << result = {
                              :description => this['description'],
                              :repository  => "git://github.com/#{user}/#{name}.git",
                              :score       => this['score'],
                              :name        => name.gsub(/radiant[-_](.*)/i, '\1').gsub(/(.*)[_-]extension/i, '\1').gsub(/-/, '_'),
                              :url         => url,
                              :zip         => "http://github.com/#{user}/#{name}/zipball/master"
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
                              :name        => this['name'].gsub(/radiant-(.*)-extension/, '\1'),
                              :gem         => this['gem_uri'],
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

    def filter
      results = []
      self.each { |this|
        if this[:name].to_s =~ /radiant/i or this[:description].to_s =~ /radiant/i or this[:repository].to_s =~ /radiant/i
          results << this
        end
      } if self.length > 0
      return results
    end

    def pick query
      if self.any?
        exact_matches = []
        fuzzy_matches = []
        self.each { |this|
          name = this[:name]
          case
          when name == query
            exact_matches << this
          when name.include?(query)
            fuzzy_matches << this
          end
        }
        if exact_matches.any?
          case
          when exact_matches.one?
            return exact_matches[0]
          else
            make_the_user_choose query, exact_matches
          end
        elsif fuzzy_matches.any?
          case
          when fuzzy_matches.one?
            return fuzzy_matches[0]
          else
            make_the_user_choose query, fuzzy_matches
          end
        else
          raise 'No matches found'
        end
      else
        raise "No matches found"
      end
    end

    def make_the_user_choose query, matches
      puts "More than one extension matched '#{query}'"
      puts "Please choose the extension you would like installed:"
      show_options matches
      choice = user_choice
      return matches[choice - 1]
    end

    def show_options matches
      matches.each { |this|
        option = matches.index(this) + 1
        name = this[:name]
        user = this[:repository].gsub(/git:\/\/github\.com\/(.*)\/.+\.git/, '\1')
        used = "#{option}. #{name} [#{user}] ".length
        puts "#{option}. #{name} [#{user}] #{this[:description][0...(69 - used)]}..."
      }
    end

    def user_choice
      print 'Extension number: '
      choice = STDIN.gets.chomp.to_i
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
   INSTALL: ray add #{name}
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
