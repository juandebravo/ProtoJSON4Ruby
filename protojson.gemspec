# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "protojson/version"

Gem::Specification.new do |s|
  s.name        = "protojson"
  s.version     = Protojson::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Juan de Bravo", "Ivan -DrSlump- Montes"]
  s.email       = ["juandebravo@gmail.com", "drslump@pollinimini.net"]
  s.homepage    = ""
  s.summary     = %q{Ruby extension to ruby-protobuf to enable three new encodings}
  s.description = %q{A Ruby gem for Google's Protocol Buffers messages using three different encodings JSON
                    based syntax instead of the original binary protocol. Supported formats

                    - Hashmap: A tipical JSON message, with key:value pairs where the key is a string representing
                        the field name.

                    - Tagmap: Very similar to Hashmap, but instead of having the field name as key it has the
                        field tag number as defined in the proto definition.

                    - Indexed: Takes the Tagmap format a further step and optimizes the size needed for
                        tag numbers by packing all of them as a string, where each character represents a tag,
                        and placing it as the first element of an array.}

  s.rubyforge_project = "protojson"

  s.files         = `git ls-files`.split("\n")
  s.files.delete("Gemfile.lock")
  s.files.delete(".gitignore")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
