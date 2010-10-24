# encoding: utf-8

desc "Run all tests in test directory"
task :test do
  system "reek -q lib"
  Dir.glob('test/*.rb').each { |test| require "#{Dir.pwd}/#{test}" }
  MiniTest::Unit.autorun
end

task :default => :test
