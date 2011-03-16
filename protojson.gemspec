# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "protojson/version"

Gem::Specification.new do |s|
  s.name        = "protojson"
  s.version     = Protojson::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Juan de Bravo", "Ivan -DrSlump- Montes"]
  s.email       = ["juan@pollinimini.com", "drslump@pollinimini.net"]
  s.homepage    = ""
  s.summary     = %q{Ruby extension to ruby-protobuf to enable JSON and INDEXED encodings}
  s.description = %q{Ruby extension to ruby-protobuf to enable JSON and INDEXED encodings}

  s.rubyforge_project = "protojson"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
