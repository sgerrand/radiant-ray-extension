# encoding: utf-8

class Array
  def subjects
    if self.has_environment?
      return self[0...-1]
    else
      return self
    end
  end

  def environment
    if self.has_environment?
      return self.last.to_s
    else
      return 'development'
    end
  end

  def has_environment?
    if self.length > 1
      return true if self.last.to_s =~ /development|production|test/i
    end
  end

  def names
    names = {}
    self.each { |entry|
      idx = self.index(entry)
      names[self[idx][:name].to_s] = idx
    }
    return names
  end

  def results
    results = ''
    self.each { |result|
      results << result.truncated
    }
    return results
  end

  def details
    details = ''
    self.each { |result|
      details << result.extended
    }
    return details
  end

  def pick query
    if self.any?
      exact_matches = Search.exact self, query
      fuzzy_matches = Search.fuzzy self, query
      case
      when exact_matches.one?
        return exact_matches.first
      when exact_matches.size > 1
        Search.prompt_for_choice exact_matches, query
      when fuzzy_matches.one?
        return fuzzy_matches.first
      when fuzzy_matches.size > 1
        Search.prompt_for_choice fuzzy_matches, query
      else
        raise 'No match found'
      end
    else
      raise 'No match found'
    end
  end
end
