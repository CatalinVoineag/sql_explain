require_relative "lib/sql_explain/version"

Gem::Specification.new do |spec|
  spec.name        = "sql_explain"
  spec.version     = SqlExplain::VERSION
  spec.authors     = [ "CatalinVoineag" ]
  spec.email       = [ "11318084+CatalinVoineag@users.noreply.github.com" ]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of SqlExplain."
  spec.description = "TODO: Description of SqlExplain."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.2.1"
end
