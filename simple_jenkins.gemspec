# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_jenkins/version'

Gem::Specification.new do |spec|
  spec.name          = "SimpleJenkins"
  spec.version       = SimpleJenkins::VERSION
  spec.authors       = ["Adam Kerr"]
  spec.email         = ["adamk@nulogy.com"]
  spec.summary       = %q{A simple library for workign with jenkins}
  spec.homepage      = "http://github.com/nulogy/simple_jenkins"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.21"

  spec.add_dependency "virtus", "~>1.0"
  spec.add_dependency "rest-client", "~>1.8"
end
