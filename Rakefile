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

task :default => :rspec

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "neustar-ws_get_data"
  gem.homepage = ""
  gem.license = "MIT"
  gem.summary = %Q{Ruby wrapper for Neustar's WS-GetData Services}
  gem.description = %Q{This gem wraps the SOAP interface for Neustar's
    WS-GetData Services. It supports both interactive and batch queries}
  gem.email = "zach@tmxcredit.com"
  gem.authors = ["Zachary Belzer"]
end
