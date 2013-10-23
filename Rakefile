#!/usr/bin/env rake
# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require "rspec/core/rake_task"


RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification...
  # see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name        = "neustar-ws_get_data"
  gem.homepage    = "http://github.com/TMXCredit/neustar-ws_get_data"
  gem.license     = "MIT"
  gem.summary     = %Q{Ruby wrapper for Neustar's WS-GetData Services}
  gem.description = "This gem wraps the SOAP interface for Neustar's" \
                    "WS-GetData Services. It supports both interactive and " \
                    "batch queries."
  gem.email       = ["rubygems@tmxcredit.com", "zach@tmxcredit.com"]
  gem.authors     = ["TMX Credit", "Zachary Belzer"]
end
