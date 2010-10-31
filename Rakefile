# encoding: utf-8

desc 'Run all tests in test directory'
task :test do
  Dir.glob('test/*.rb').each { |test| require "#{Dir.pwd}/#{test}" }
  MiniTest::Unit.autorun
end

desc 'Run Reek on all files in lib directory'
task :reek do
  require 'reek/rake/task'
  Reek::Rake::Task.new do |t|
    t.fail_on_error = false
  end
end

# desc 'Run metric_fu'
# task :metrics do
#   require 'json'
#   require 'metric_fu'
# end

task :default => :test
