# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lionel/version'

Gem::Specification.new do |gem|
  gem.name          = "lionel"
  gem.version       = Lionel::VERSION
  gem.authors       = ["Gabe Kopley"]
  gem.email         = ["gabe@coshx.com"]
  gem.description   = <<-EOF
    Engine gems are convenient for versioning and packaging static assets.  Lionel lets you use assets packaged as Engines without depending on Rails.
  EOF
  gem.summary       = %q{Use assets packaged as Engines without Rails}
  gem.homepage      = "https://github.com/gkop/lionel"
  gem.licenses      = ["MIT", "BSD", "WTFPL"]

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "nullobject"
  gem.add_development_dependency "rake"
end
