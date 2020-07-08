require_relative 'lib/shopping/cart/version'

Gem::Specification.new do |spec|
  spec.name          = "shopping-cart"
  spec.version       = Shopping::Cart::VERSION
  spec.authors       = ["pranava s balugari"]
  spec.email         = ["stalin.pranava@gmail.com"]

  spec.summary       = %q{iUS coding challenge}
  spec.description   = %q{DiUS challenge: computer store checkout system which can apply discounts on the products}
  spec.homepage      = "https://github.com/elitenomad/shopping-cart"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/elitenomad/checkout"
  spec.metadata["changelog_uri"] = "https://github.com/elitenomad/checkout"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
