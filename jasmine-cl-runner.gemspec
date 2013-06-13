# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jasmine_cl_runner/version'

Gem::Specification.new do |spec|
  spec.name          = "jasmine-cl-runner"
  spec.version       = JasmineClRunner::VERSION
  spec.authors       = ["Andrew De Ponte"]
  spec.email         = ["cyphactor@gmail.com"]
  spec.description   = %q{A Jasmine JavaScript test running that lets you run tests on the command-line similar to RSpec.}
  spec.summary       = %q{A command-line Jasmine JavaScript test runner.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara", "~> 2.1.0"
  spec.add_dependency "poltergeist", "~> 1.3.0"
  spec.add_dependency "sinatra", "~> 1.4.3"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13.0"
end
