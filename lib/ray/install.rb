# methods for installation
class Ray

  def install
    @options.each { |extension|
      if gem_available? extension
        gem_install extension
      else
        traditional_install extension
      end
    }
  end

  def gem_available? extension
    if gem_in_path?
      if gem_available_locally? extension
        @error = "The '#{extension}' gem is already installed."
        return true
      else
        @error = nil
        `gem list --remote radiant-#{extension}-extension`.include?(extension) ? true : false
      end
    end
  end

  def gem_available_locally? extension
    `gem list --local radiant-#{extension}-extension`.include?(extension) ? true : false
  end

  def gem_in_path?
    `gem -v`.include?('1.3') ? true : false
  end

  def gem_install extension
    @error if @error
    sudo_gem?
    system "#{@sudo_gem}gem install radiant-#{extension}-extension" unless @error
    load_extension_gem extension
  end

  def load_extension_gem extension
    @pwd = Dir.pwd
    @environment = ''
    File.foreach("#{@pwd}/config/environment.rb", 'r') do |line|
      @environment += line
    end
    @environment.gsub!(/(Radiant::Initializer.run do \|config\|\n)/, "\\1  config.gem 'radiant-#{extension}-extension', :lib => false\n")
    File.open("#{@pwd}/config/environment.rb", 'w') do |file|
      file.puts @environment
    end
  end

  def sudo_gem?
    sudo_gem_preference = get_sudo_gem_preference
    if sudo_gem_preference
      @sudo_gem = sudo_gem_preference.include?('y') ? 'sudo ' : ''
    else
      print "Do you normally use 'sudo' before your gem commands? (y/n) "
      @sudo_gem = STDIN.gets.strip
    end
  end

  def traditional_install extension
    p "traditional_install"
  end

end
