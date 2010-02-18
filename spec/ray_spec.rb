require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ray" do

  require 'fileutils'

  def create_preference_file!
    choices = [ { :download => 'git',  :sudo_gem => 'y', :restart => 'mongrel_cluster' },
                { :download => 'git',  :sudo_gem => 'n', :restart => 'mongrel'         },
                { :download => 'git',  :sudo_gem => 'y', :restart => 'passenger'       },
                { :download => 'git',  :sudo_gem => 'n', :restart => 'thin'            },
                { :download => 'git',  :sudo_gem => 'y', :restart => 'unicorn'         },
                { :download => 'http', :sudo_gem => 'n', :restart => 'mongrel_cluster' },
                { :download => 'http', :sudo_gem => 'y', :restart => 'mongrel'         },
                { :download => 'http', :sudo_gem => 'n', :restart => 'passenger'       },
                { :download => 'http', :sudo_gem => 'y', :restart => 'thin'            },
                { :download => 'http', :sudo_gem => 'n', :restart => 'unicorn'         }
              ]
    @preferences = choices[rand(10)]
    FileUtils.mkdir_p "#{Dir.pwd}/config"
    File.open("#{Dir.pwd}/config/ray_preferences.yml", 'w') do |line|
      line.puts "---\n"
      line.puts "  download: #{@preferences[:download]}\n"
      line.puts "  restart: #{@preferences[:restart]}\n"
      line.puts "  sudo_gem: #{@preferences[:sudo_gem]}\n"
    end
  end

  def create_no_sudo_gem_preference_file!
    FileUtils.mkdir_p "#{Dir.pwd}/config"
    File.open("#{Dir.pwd}/config/ray_preferences.yml", 'w') do |line|
      line.puts "---\n"
      line.puts "  download: http\n"
      line.puts "  restart: thin\n"
      line.puts "  sudo_gem: n\n"
    end
  end

  def create_environment_file!
    FileUtils.mkdir_p "#{Dir.pwd}/config"
    File.open("#{Dir.pwd}/config/environment.rb", 'w') do |line|
      line.puts "Radiant::Initializer.run do |config|\n"
      line.puts "end\n"
    end
  end

  def empty_preference_file!
    FileUtils.mkdir_p "#{Dir.pwd}/config"
    File.open("#{Dir.pwd}/config/ray_preferences.yml", 'w')
  end

  def install_empty_extension
    FileUtils.mkdir_p "#{Dir.pwd}/vendor/extensions/help"
  end

  def install_help_extension
    FileUtils.mkdir_p "#{Dir.pwd}/vendor/extensions"
    FileUtils.cp_r "#{Dir.pwd}/mocks/extensions/help", "#{Dir.pwd}/vendor/extensions/help"
  end

  def cleanup_config_files!
    FileUtils.rm_r "#{Dir.pwd}/config"
  end

  def cleanup_temporary_extensions!
    FileUtils.rm_r "#{Dir.pwd}/vendor"
  end

  def install_kramdown_filter!
    unless `gem list radiant-kramdown_filter-extension`.include? 'radiant-kramdown_filter-extension'
      system "gem install #{Dir.pwd}/mocks/extensions/radiant-kramdown_filter-extension-1.0.5.gem --no-ri --no-rdoc"
      @uninstall_kramdown_filter
    end
  end

  def uninstall_kramdown_filter!
    system "gem uninstall radiant-kramdown_filter-extension" if `gem list radiant-kramdown_filter-extension`.include? 'radiant-kramdown_filter-extension'
  end

  it "should return a new Ray." do
    Ray.new(['']).should be_instance_of Ray
  end

  it "should use the first argument as the action." do
    @ray = Ray.new ['option1', 'option2', 'option3']
    @ray.action.should == "option1"
  end

  it "should use all but the first argument as the options." do
    @ray = Ray.new ['option1', 'option2', 'option3']
    @ray.options.should == ['option2', 'option3']
  end

  it "should return an error message for invalid actions." do
    @ray = Ray.new ['fail', 'abc', 'xyz']
    @ray.error.should include "'fail' is not a valid command."
  end

  it "should not return an error message for valid actions." do
    actions = ['enable', 'disable', 'help', 'install']
    actions.each { |action|
      @ray = Ray.new [action]
      @ray.error.should == ''
    }
  end

  it "should be able to get the user's download preference." do
    create_preference_file!
    @ray = Ray.new ['install']
    @ray.get_download_preference.should == @preferences[:download]
    cleanup_config_files!
  end

  it "should be able to set the user's download preference." do
    create_preference_file!
    @ray = Ray.new ['setup', 'download', 'http']
    @ray.set_preferences
    @ray.get_download_preference.should == 'http'
    cleanup_config_files!
  end

  it "should save an existing restart preference while setting the download preference." do
    create_preference_file!
    @ray = Ray.new ['setup', 'download', 'http']
    @ray.set_preferences
    @ray.get_restart_preference.should == @preferences[:restart]
    cleanup_config_files!
  end

  it "should save an existing sudo_gem preference while setting the download preference." do
    create_preference_file!
    @ray = Ray.new ['setup', 'download', 'http']
    @ray.set_preferences
    @ray.get_sudo_gem_preference.should == @preferences[:sudo_gem]
    cleanup_config_files!
  end

  it "should be able to get the user's restart preference." do
    create_preference_file!
    @ray = Ray.new ['install']
    @ray.get_restart_preference.should == @preferences[:restart]
    cleanup_config_files!
  end

  it "should be able to set the user's restart preference." do
    empty_preference_file!
    @ray = Ray.new ['setup', 'restart', 'passenger']
    @ray.set_preferences
    @ray.get_restart_preference.should == 'passenger'
    cleanup_config_files!
  end

  it "should save an existing download preference while setting the restart preference." do
    create_preference_file!
    @ray = Ray.new ['setup', 'restart', 'mongrel_cluster']
    @ray.set_preferences
    @ray.get_download_preference.should == @preferences[:download]
    cleanup_config_files!
  end

  it "should save an existing sudo_gem preference while setting the restart preference." do
    create_preference_file!
    @ray = Ray.new ['setup', 'restart', 'thin']
    @ray.set_preferences
    @ray.get_sudo_gem_preference.should == @preferences[:sudo_gem]
    cleanup_config_files!
  end

  it "should be able to get the user's sudo gem preference." do
    create_preference_file!
    @ray = Ray.new ['install']
    @ray.get_sudo_gem_preference.should == @preferences[:sudo_gem]
    cleanup_config_files!
  end

  it "should be able to set the user's sudo gem preference." do
    empty_preference_file!
    @ray = Ray.new ['setup', 'sudo_gem', 'y']
    @ray.set_preferences
    @ray.get_sudo_gem_preference.should == 'y'
    cleanup_config_files!
  end

  it "should save an existing download preference while setting the sudo_gem preference." do
    create_preference_file!
    @ray = Ray.new ['setup', 'sudo_gem', 'y']
    @ray.set_preferences
    @ray.get_download_preference.should == @preferences[:download]
    cleanup_config_files!
  end

  it "should save an existing restart preference while setting the sudo_gem preference." do
    create_preference_file!
    @ray = Ray.new ['setup', 'sudo_gem', 'n']
    @ray.set_preferences
    @ray.get_restart_preference.should == @preferences[:restart]
    cleanup_config_files!
  end

  it "should show the help screen." do
    @ray = Ray.new ['help']
    @ray.help.should include 'friendly extension management for Radiant CMS'
  end

  it "should move disabled extensions to ./vendor/extensions/.disabled/extension_name." do
    install_empty_extension
    @ray = Ray.new ['disable', 'help']
    @ray.disable
    File.exist?("#{Dir.pwd}/vendor/extensions/.disabled/help").should == true
    cleanup_temporary_extensions!
  end

  it "should remove disabled extensions from ./vendor/extensions/extension_name." do
    install_empty_extension
    @ray = Ray.new ['disable', 'help']
    @ray.disable
    File.exist?("#{Dir.pwd}/vendor/extensions/help").should == false
    cleanup_temporary_extensions!
  end

  it "should move enabled extensions to ./vendor/extensions/extension_name." do
    install_empty_extension
    @ray = Ray.new ['disable', 'help']
    @ray.disable
    @ray.enable
    File.exist?("#{Dir.pwd}/vendor/extensions/.disabled/help").should == false
    cleanup_temporary_extensions!
  end

  it "should remove enabled extensions from ./vendor/extensions/.disabled/extension_name." do
    install_empty_extension
    @ray = Ray.new ['disable', 'help']
    @ray.disable
    @ray.enable
    File.exist?("#{Dir.pwd}/vendor/extensions/help").should == true
    cleanup_temporary_extensions!
  end

  it "should return an error when disabling extensions that are not installed." do
    install_empty_extension
    @ray = Ray.new ['disable', 'xxx']
    @ray.disable
    @ray.error.should include "The 'xxx' extension is not installed."
    cleanup_temporary_extensions!
  end

  it "should not enable extensions that are not disabled." do
    install_empty_extension
    @ray = Ray.new ['enable', 'xxx']
    @ray.move_to_disabled 'help'
    @ray.enable
    @ray.error.should include "The 'xxx' extension is not disabled."
    cleanup_temporary_extensions!
  end

  it "should install the extension as a gem when available" do
    create_no_sudo_gem_preference_file!
    create_environment_file!
    install_kramdown_filter!
    @ray = Ray.new ['install', 'kramdown_filter']
    @ray.install
    `gem list radiant-kramdown_filter-extension`.should include 'radiant-kramdown_filter-extension'
    cleanup_config_files!
  end

  it "should not install to vendor/extensions when gem is available" do
    create_no_sudo_gem_preference_file!
    create_environment_file!
    @ray = Ray.new ['install', 'kramdown_filter']
    @ray.install
    File.exist?("#{Dir.pwd}/vendor/extensions/kramdown_filter").should == false
    cleanup_config_files!
  end

  it "should check for a previously installed version of the gem" do
    create_no_sudo_gem_preference_file!
    create_environment_file!
    @ray = Ray.new ['install', 'kramdown_filter']
    @ray.install
    @ray.error.should include "The 'kramdown_filter' gem is already installed."
    cleanup_config_files!
  end

  it "should load an installed gem into config/environment.rb" do
    create_no_sudo_gem_preference_file!
    create_environment_file!
    @ray = Ray.new ['install', 'kramdown_filter']
    @ray.install
    File.foreach("#{Dir.pwd}/config/environment.rb") do |line|
      @environment = true if line.include? "config.gem 'radiant-kramdown_filter-extension', :lib => false"
    end
    @environment.should == true
    cleanup_config_files!
    uninstall_kramdown_filter! if @uninstall_kramdown_filter
  end

  it "should install extensions with git."
  it "should install extensions with http."

end
