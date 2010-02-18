# methods showing help screens
class Ray

  def help
"Ray: friendly extension management for Radiant CMS.

  BASIC USAGE:

  ray disable extension_name
  ray enable extension_name
  ray install extension_name
  ray uninstall extension_name

For advanced usage and more examples refer to the Ray documentation:
  http://johnmuhl.github.com/radiant-ray-extension/"
  end

  def documentation
    puts "
========================================================
Opening the documentation in your default web browser..."
    Launchy.open("http://johnmuhl.github.com/radiant-ray-extension/")
  end

end
