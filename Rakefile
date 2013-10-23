#!/usr/bin/env rake
# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'rake'
require 'rspec/core/rake_task'
require './lib/neustar-ws_get_data/version'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec
