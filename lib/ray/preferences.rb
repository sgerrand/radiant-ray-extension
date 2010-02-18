# methods for getting and setting preferences
class Ray

  def get_preferences
    { :download => get_download_preference,
      :restart  => get_restart_preference,
      :sudo_gem => get_sudo_gem_preference }
  end

  def get_download_preference
    begin
      @download = YAML::load_file("#{Dir.pwd}/config/ray_preferences.yml")['download'].strip
    rescue Exception; end
  end

  def get_restart_preference
    begin
      @restart = YAML::load_file("#{Dir.pwd}/config/ray_preferences.yml")['restart'].strip
    rescue Exception; end
  end

  def get_sudo_gem_preference
    begin
      @sudo_gem = YAML::load_file("#{Dir.pwd}/config/ray_preferences.yml")['sudo_gem'].strip
    rescue Exception; end
  end

  def set_preferences
    set_download_preference if @options.include? 'download'
    set_restart_preference if @options.include? 'restart'
    set_sudo_gem_preference if @options.include? 'sudo_gem'
  end

  def set_download_preference
    get_other_preferences
    File.open("#{Dir.pwd}/config/ray_preferences.yml", 'w') do |line|
      line.puts "---\n  download: #{@options[1]}\n"
    end
    @download = nil
    restore_other_preferences
  end

  def set_restart_preference
    get_other_preferences
    File.open("#{Dir.pwd}/config/ray_preferences.yml", 'w') do |line|
      line.puts "---\n  restart: #{@options[1]}\n"
    end
    @restart = nil
    restore_other_preferences
  end

  def set_sudo_gem_preference
    get_other_preferences
    File.open("#{Dir.pwd}/config/ray_preferences.yml", 'w') do |line|
      line.puts "---\n  sudo_gem: #{@options[1]}\n"
    end
    @sudo_gem = nil
    restore_other_preferences
  end

  def get_other_preferences
    get_download_preference
    get_restart_preference
    get_sudo_gem_preference
  end

  def restore_other_preferences
    @pwd = Dir.pwd
    File.open("#{@pwd}/config/ray_preferences.yml", 'a') do |line|
      line.puts "  download: #{@download}\n" if @download
      line.puts "  restart: #{@restart}\n" if @restart
      line.puts "  sudo_gem: #{@sudo_gem}\n" if @sudo_gem
    end
  end

end
