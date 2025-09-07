lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "psl-domain-extractor/version"

Gem::Specification.new do |s|
  s.name = "psl-domain-extractor"
  s.summary = "Public Suffix List based domain extractor"
  s.version = PslDomainExtractor::VERSION
  s.author = "Ruben Arakelyan"
  s.description = "Ruby gem for extracting domains, subdomains and public suffixes from hostnames using the Public Suffix List"
  s.email = "ruben@arakelyan.uk"
  s.homepage = "https://github.com/rubenarakelyan/psl-domain-extractor"
  s.license = "MIT"
  s.required_ruby_version = ">= 3.2.8"
  s.platform = Gem::Platform::RUBY
  s.files = Dir.glob("lib/**/*") + [
    "psl/public_suffix_list.dat",
    "CHANGELOG.md",
    "Gemfile",
    "LICENSE",
    "README.md",
    "psl-domain-extractor.gemspec"
  ]
  s.require_paths = ["lib"]
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/rubenarakelyan/psl-domain-extractor/issues",
    "changelog_uri" => "https://github.com/rubenarakelyan/psl-domain-extractor/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/psl-domain-extractor",
    "source_code_uri" => "https://github.com/rubenarakelyan/psl-domain-extractor",
    "wiki_uri" => "https://github.com/rubenarakelyan/psl-domain-extractor/wiki",
    "funding_uri" => "https://github.com/sponsors/rubenarakelyan",
    "rubygems_mfa_required" => "true"
  }

  s.cert_chain = ["certs/rubena.pem"]
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  s.add_development_dependency "irb", "~> 1.15"
  s.add_development_dependency "pry-byebug", "~> 3.11"
  s.add_development_dependency "rake", "~> 13.3"
  s.add_development_dependency "readline", "~> 0.0.4"
  s.add_development_dependency "rspec", "~> 3.13"
  s.add_development_dependency "rubocop", "~> 1.80"
  s.add_development_dependency "simplecov", "~> 0.22"
end
