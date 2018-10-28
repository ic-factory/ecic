# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ecic/version'

Gem::Specification.new do |spec|
  spec.name          = "ecic"
  spec.version       = Ecic::VERSION
  spec.authors       = ["Torben Fox Jacobsen"]
  spec.email         = ["ecic@ic-factory.com"]
  spec.licenses       = ['LGPL-3.0']
  spec.summary       = %q{Easy-IC : provides a framework for ASIC and FPGA projects that favors convention over configuration.}
  spec.description   = %q{This gem allows you to easily create a new ASIC/FPGA project with a file structure and support tools that ensures consistency between your projects and gets you up to speed in no time. To create a new project simply type 'ecic new PATH'.}
  spec.homepage      = "https://github.com/ic-factory/ecic"

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.4.4'
  spec.add_dependency "thor", '~> 0.20'
  spec.add_dependency "colorize", '~> 0.8'
  spec.add_dependency "rake", '~> 12.3'
  spec.add_dependency "activesupport", '~> 5.2'

  spec.add_development_dependency "bundler", '~> 1.16'
  spec.add_development_dependency "byebug", '~> 10.0'
  spec.add_development_dependency "rspec", '~> 3.8'
end
