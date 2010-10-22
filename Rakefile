# encoding: utf-8

desc "Run all tests in test directory"
task :test do
  Dir.glob('test/*.rb').each { |test| require "#{Dir.pwd}/#{test}" }
  MiniTest::Unit.autorun
end

task :default => :test
