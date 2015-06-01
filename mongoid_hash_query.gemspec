# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_hash_query/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid_hash_query"
  spec.version       = MongoidHashQuery::VERSION
  spec.authors       = ["Filippos Vasilakis"]
  spec.email         = ["vasilakisfil@gmail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{Simple gem that allows you to run any Mongoid query using a hash API. Perfect for RESTful APIs}
  spec.description   = %q{Simple gem that allows you to run any Mongoid query using a hash API. Perfect for RESTful APIs}
  spec.homepage      = "https://github.com/kollegorna/mongoid_hash_query"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
