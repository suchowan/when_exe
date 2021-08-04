# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "when_exe"

Gem::Specification.new do |s|
  s.name        = "when_exe"
  s.version     = When::VERSION
  s.license     = "MIT"
  s.authors     = ["Takashi SUGA"]
  s.email       = ["suchowan@box.email.ne.jp"]
  s.homepage    = "http://www.asahi-net.or.jp/~dd6t-sg/"
  s.summary     = %q{A multicultural and multilingualized calendar library based on ISO 8601-2004, ISO 19108, RFC 5545(iCalendar) and RFC6350}
  s.description = %q{A multicultural and multilingualized calendar library based on ISO 8601-2004, ISO 19108, RFC 5545(iCalendar) and RFC6350. JSON-LD formats for TemporalPosition and TemporalReferenceSystem are available. This version is a beta version and in the evaluation stage. So, its APIs may be changed in future. Please refer to http://suchowan.at.webry.info/theme/a543700674.html for the recent history (Sorry only in Japanese).}

# s.rubyforge_project = "when_exe"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 2.2.2'

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
