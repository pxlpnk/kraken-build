# -*- encoding: utf-8 -*-
require File.expand_path('../lib/kraken-build/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["at"]
  gem.email         = ["at@an-ti.eu"]
  gem.description   = %q{A simple tool that generates a job for each github branch in your Jenkins environment}
  gem.summary       = %q{Managing your feature branches on Jenkins and Github}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "kraken-build"
  gem.require_paths = ["lib"]
  gem.version       = Kraken::Build::VERSION


  gem.add_development_dependency "rspec"
  gem.add_dependency "rake"
  gem.add_dependency "httparty"
  gem.add_dependency "nokogiri"
  # Other attributes omitted

end
