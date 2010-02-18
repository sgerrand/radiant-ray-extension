# methods for disabling extensions
class Ray

  def disable
    @pwd = Dir.pwd
    @options.each { |option| move_to_disabled option }
  end

  def move_to_disabled extension
    if installed_extension? extension
      create_disabled_directory
      FileUtils.mv "#{@pwd}/vendor/extensions/#{extension}", "#{@pwd}/vendor/extensions/.disabled/#{extension}"
    else
      @error = "The '#{extension}' extension is not installed."
    end
  end

  def create_disabled_directory
    FileUtils.mkdir_p "#{@pwd}/vendor/extensions/.disabled"
  end

  def installed_extension? extension
    File.exist?("#{@pwd}/vendor/extensions/#{extension}") ? true : false
  end

end
