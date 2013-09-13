require "date"

Gem::Specification.new do |gem|
  gem.name          = "gpx2"
  gem.version       = "1.0.0"

  gem.authors       = ["Thomas Cyron"]
  gem.date          = Date.today
  gem.email         = ["thomas@thcyron.de"]
  gem.homepage      = "http://github.com/nano/gpx2"

  gem.description   = "GPX 1.1 file parser and generator"
  gem.summary       = gem.description

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(/^spec/)
  gem.require_paths = ["lib"]

  gem.add_dependency "nokogiri", "~> 1.6.0"
  gem.add_development_dependency "rspec", "~> 2.14.1"
  gem.add_development_dependency "rake"
end
