# -*- encoding: utf-8 -*-
 $:.push File.expand_path("../lib", __FILE__)
require "neustar-ws_get_data/version"

Gem::Specification.new do |s|
  s.name = "neustar-ws_get_data"
  s.version = Neustar::WsGetData::VERSION

  s.authors = ["TMX Credit", "Zachary Belzer"]
  s.date = "2013-10-23"
  s.description = "This gem wraps the SOAP interface for Neustar's WS-GetData Services. It supports both interactive and batch queries."
  s.email = ["rubygems@tmxcredit.com", "zach@tmxcredit.com"]
  s.homepage = "http://github.com/TMXCredit/neustar-ws_get_data"
  s.licenses = ["MIT"]
  s.summary = "Ruby wrapper for Neustar's WS-GetData Services"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<savon>, ["~> 2.2"])

  s.add_development_dependency(%q<yard>, [">= 0"])
  s.add_development_dependency(%q<bundler>, [">= 0"])
  s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
  s.add_development_dependency(%q<rspec>, ["~> 2.14.0"])
  s.add_development_dependency(%q<metric_fu>, [">= 0"])
end

