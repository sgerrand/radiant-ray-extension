# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = 'radiant-ray'
  s.version     = File.read 'VERSION'
  s.date        = Time.new.strftime '%Y-%m-%d'
  s.summary     = 'Friendly extension management for Radiant CMS'
  s.description = '' # TODO: add a description

  s.authors   = ['john muhl']
  s.homepage  = 'http://ray.johnmuhl.com/'
  s.email     = 'git@johnmuhl.com'

  s.rubygems_version = Gem::VERSION

  s.require_paths = ['lib']

  s.add_runtime_dependency 'json', '~> 1.4'

  s.add_development_dependency 'minitest', '~> 1.7'

  s.files = [
    'lib/ray.rb',
    'lib/ray/extension.rb',
    'lib/ray/preferences.rb',
    'lib/ray/search.rb',
    'LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.test_files = [
    '.autotest',
    'test/test_ray.rb',
    'test/test_ray_extension.rb',
    'test/test_ray_preferences.rb',
    'test/test_ray_search.rb',
    'test/test_ray_search_slow.rb',
    'test/mocks/.ray/preferences',
    'test/mocks/.ray/ray_global_preferences',
    'test/mocks/.ray/ray_local_preferences'
  ]
end
