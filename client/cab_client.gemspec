# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cab_client/version"

Gem::Specification.new do |spec|
  spec.name          = "cab_client"
  spec.version       = CabClient::VERSION
  spec.authors       = ["Carlos Castellanos Vera"]
  spec.email         = ["me@carloscastellanosvera.com"]

  spec.summary       = "The client of the Cab API"
  spec.description   = "The ruby client of the Cab API"
  spec.homepage      = "http://example.com"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "http", "~> 4.1.1"
  spec.add_dependency "oj", "~> 3.7.12"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 5.0.0"
  spec.add_development_dependency "webmock", "~> 3.6.0"
end
