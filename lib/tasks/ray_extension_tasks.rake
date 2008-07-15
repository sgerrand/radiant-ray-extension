namespace :ray do

  def restart_server
    if ENV['RESTART'].nil?
      puts "You should restart your server now. Try adding RESTART=mongrel_cluster or RESTART=passenger next time."
    else
      server = ENV['RESTART']
      if server == "mongrel_cluster"
        system "mongrel_rails cluster::restart"
        puts "Your mongrel_cluster has been restarted."
      elsif server == "passenger"
        system "touch tmp/restart.txt"
        puts "Your passengers have been restarted."
      else
        puts "I don't know how to restart #{ENV['RESTART']}. You'll need to restart your server manually."
      end
    end
  end

  def install_extension
    name = ENV['NAME']
    github_name = name.gsub(/\_/, "-")
    vendor_name = name.gsub(/\-/, "_")
    radiant_git = "git://github.com/radiant/"
    if ENV['HUB'].nil?
      ext_repo = radiant_git
    else
      ext_repo = "git://github.com/#{ENV['HUB']}/"
    end
    system "git clone #{ext_repo}radiant-#{github_name}-extension.git vendor/extensions/#{vendor_name}"
    system "rake radiant:extensions:#{vendor_name}:migrate"
    system "rake radiant:extensions:#{vendor_name}:update"
    puts "The #{vendor_name} extension has been installed. Use the :disable command to disable it later."
  end

  def install_custom_extension
    name = ENV['NAME']
    vendor_name = name.gsub(/\-/, "_")
    ext_repo = "git://github.com/#{ENV['HUB']}/"
    system "git clone #{ext_repo}/#{ENV['FULLNAME']}.git vendor/extensions/#{vendor_name}"
    system "rake radiant:extensions:#{vendor_name}:migrate"
    system "rake radiant:extensions:#{vendor_name}:update"
    puts "The #{vendor_name} extension has been installed. Use the :disable command to disable it later."
  end

  desc "Install extensions from github. `NAME=extension_name` is required; if you specify `FULLNAME` you must also specify `HUB=github_user_name`. You can also use `HUB=user` with the `NAME` option to install from outside the Radiant repository."
  task :install do
      if ENV['NAME'].nil?
        puts "You have to tell me which extension to install. Try something like: rake ray:install NAME=extension_name"

      else
        $verbose = false
        `git --version` rescue nil
        unless !$?.nil? && $?.success?
          # TODO Make sure these are actual commands
          $stderr.puts "ERROR: Must have git available in the PATH to install extensions from github.\nSome common commands for instaling git are:\n`aptitude install git-core`\n`port install git-core`\n`emerge git`\nRedHat users should use the RPMs available here: http://kernel.org/pub/software/scm/git/RPMS/"
          exit 1
        end
        mkdir_p "vendor/extensions"

        case
        when ENV['FULLNAME']
          if ENV['HUB'].nil?
            puts "You have to tell me which github user to get the extension from. Try something like: rake ray:install FULLNAME=sweet-sauce-for-radiant HUB=bob NAME=sweet-sauce"
          else
            install_custom_extension
            restart_server
          end

        when ENV['HUB']
          if ENV['FULLNAME'].nil?
            install_extension
          else
            install_custom_extension
          end
          restart_server

        else
          install_extension
          restart_server
        end

      end
  end

  desc "enable extensions"
  task :enable do
    if ENV['NAME'].nil?
      puts "You have to tell me which extension to enable. Try something like: rake ray:enable NAME=extension_name"

    else
      name = ENV['NAME']
      vendor_name = name.gsub(/\-/, "_")
      mkdir_p "vendor/extensions"
      system "mv vendor/extensions_disabled/#{vendor_name} vendor/extensions/#{vendor_name}"
      puts "The #{ENV['NAME']} extension has been enabled. Use the :disable command to re-enable it later."
      restart_server
    end
  end

  desc "disable extensions"
  task :disable do
    if ENV['NAME'].nil?
      puts "You have to tell me which extension to disable. Try something like: rake ray:disable NAME=extension_name"

    else
      name = ENV['NAME']
      vendor_name = name.gsub(/\-/, "_")
      mkdir_p "vendor/extensions_disabled"
      system "mv vendor/extensions/#{vendor_name} vendor/extensions_disabled/#{vendor_name}"
      puts "The #{ENV['NAME']} extension has been disabled. Use the :enable command to re-enable it later."
      restart_server
    end
  end

  namespace :deploy do

    

  end

end