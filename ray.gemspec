# encoding: utf-8

Gem::Specification.new do |s|
  s.name = 'ray'
  s.version = File.read 'VERSION'
  s.date = Time.new.strftime '%Y-%m-%d'
  s.summary = 'Friendly extension management for Radiant CMS'
  s.description = '' # TODO: add a description

  s.authors = ['john muhl']
  s.homepage = 'http://ray.johnmuhl.com/'
  s.email = 'git@johnmuhl.com'

  s.rubygems_version = Gem::VERSION

  s.require_paths = ['lib']

  s.add_runtime_dependency 'json', '>= 0'

  s.add_development_dependency 'minitest', '>= 0'

  s.files = [
    '.autotest',
    '.gitignore',
    'LICENSE',
    'README.md',
    'Rakefile',
    'lib/ray.rb',
    'lib/ray/extension.rb',
    'lib/ray/preferences.rb',
  ]

  s.test_files = [
    'test/test_ray.rb',
    'test/test_ray_extensions.rb',
    'test/test_ray_preferences.rb',
    'test/mocks/ray_global_preferences',
    'test/mocks/ray_local_preferences'
  ]
end
