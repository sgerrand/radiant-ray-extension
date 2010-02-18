# methods for disabling extensions
class Ray

  def enable
    @pwd = Dir.pwd
    @options.each { |option| move_to_extensions option }
  end

  def move_to_extensions extension
    if disabled_extension? extension
      FileUtils.mv "#{@pwd}/vendor/extensions/.disabled/#{extension}", "#{@pwd}/vendor/extensions/#{extension}"
    else
      @error = "The '#{extension}' extension is not disabled."
    end
  end

  def disabled_extension? extension
    File.exist?("#{@pwd}/vendor/extensions/.disabled/#{extension}") ? true : false
  end

end
