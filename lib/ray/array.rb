# Additional methods for working with Ray's arguments array
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
end
