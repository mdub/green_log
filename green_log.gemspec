# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "green_log/version"

Gem::Specification.new do |spec|
  spec.name          = "green_log"
  spec.version       = GreenLog::VERSION
  spec.authors       = ["Mike Williams"]
  spec.email         = ["mike.williams@greensync.com.au"]

  spec.summary       = "Structured logging for cloud-native systems."
  spec.homepage      = "https://github.com/greensync/green_log"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob("{bin,lib}/**/*") + %w[
      README.md Gemfile Gemfile.lock Rakefile LICENSE.txt json-sequence.gemspec
    ]
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "values", "~> 1.8"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.77"

end
