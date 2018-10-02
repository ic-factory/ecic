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

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
