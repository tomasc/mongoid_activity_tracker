# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_activity_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid_activity_tracker"
  spec.version       = MongoidActivityTracker::VERSION
  spec.authors       = ["Tomas Celizna"]
  spec.email         = ["tomas.celizna@gmail.com"]
  spec.description   = %q{Minimal set of classes and modules to help with activity tracking.}
  spec.summary       = %q{Minimal set of classes and modules to help with activity tracking.}
  spec.homepage      = "https://github.com/tomasc/mongoid_activity_tracker"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mongoid", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
end