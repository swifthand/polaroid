# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polaroid'

Gem::Specification.new do |spec|
  spec.name           = "polaroid"
  spec.version        = Polaroid::VERSION
  spec.platform       = Gem::Platform::RUBY
  spec.authors        = ["Paul Kwiatkowski"]
  spec.email          = ["paul@groupraise.com"]
  spec.summary        = %q{Polaroid provides shortcuts to capture the state of a Ruby object, and can construct a fake object later to mimic that state.}
  spec.description    = %q{Polaroid provides shortcuts to capture the state of a Ruby object, and can construct a fake object later to represents that state. The goal is to "Never send a Hash to do an Object's job" when performing common tasks such as, sending data to a background worker as JSON, or otherwise.}
  spec.homepage       = "https://github.com/swifthand/polaroid"
  spec.license        = "MIT"

  spec.files          = `git ls-files -z`.split("\x0")
  # spec.executables    = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths  = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "immutable_struct", "~> 1.1"
  spec.add_runtime_dependency "json", "~> 1.8"
end
