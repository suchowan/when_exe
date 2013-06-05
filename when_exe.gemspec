# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "when_exe/version"

Gem::Specification.new do |s|
  s.name        = "when_exe"
  s.version     = When::VERSION
  s.authors     = ["Takashi SUGA"]
  s.email       = ["suchowan@box.email.ne.jp"]
  s.homepage    = "http://www2u.biglobe.ne.jp/~suchowan/u/wiki.cgi?Calendar%2FWhen%2FRuby%2F2%2EAPI%E3%81%AE%E4%BD%BF%E7%94%A8%E4%BE%8B%2F4%2E%E6%99%82%E9%96%93%E9%96%93%E9%9A%94%2F%E6%9C%80%E5%B0%8F%E3%82%BB%E3%83%83%E3%83%88"
  s.summary     = %q{A multicultural and multilingualized calendar library based on ISO 8601, ISO 19108 and RFC 5545}
  s.description = %q{This library supports ISO 8601, ISO 19108 and RFC 5545. This version is a beta version and in the evaluation stage. So, its APIs may be changed in future.}

  s.rubyforge_project = "when_exe"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
