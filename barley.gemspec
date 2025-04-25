require_relative "lib/barley/version"

Gem::Specification.new do |spec|
  spec.name = "barley"
  spec.version = Barley::VERSION
  spec.authors = ["Cedric Delalande"]
  spec.email = ["weengs@moskitohero.com"]
  spec.summary = "Barley is a dead simple, fast, and efficient ActiveModel serializer."
  spec.description = "Cerealize your ActiveModel objects into flat hashes with a dead simple, yet versatile DSL, and caching and type-checking baked in. Our daily bread is to make your API faster."
  spec.homepage = "https://github.com/moskitohero/barley"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/moskitohero/barley"
  spec.metadata["changelog_uri"] = "https://github.com/moskitohero/barley/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://rubydoc.info/github/MoskitoHero/barley/main"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "dry-types", "~> 1.7.1"
  spec.add_dependency "rails", ">= 7.1.0"
end
