require "psl-domain-extractor/extractors"
require "psl-domain-extractor/public_suffix_list"

module PslDomainExtractor
  def self.extract_domain(domain)
    rules = rules_from_psl_file
    Extractors.new(rules).extract_domain(domain)
  end

  def self.extract_subdomain(domain)
    rules = rules_from_psl_file
    Extractors.new(rules).extract_subdomain(domain)
  end

  def self.extract_public_suffix(domain)
    rules = rules_from_psl_file
    Extractors.new(rules).extract_public_suffix(domain)
  end

  # These two methods allow this class to be used with Rails as the domain extractor
  # for `ActionDispatch`. Add the following to your Rails configuration:
  # ```ruby
  # config.action_dispatch.domain_extractor = PslDomainExtractor
  # ```
  def self.domain_from(host, _tld_length = nil)
    extract_domain(host)
  end

  def self.subdomains_from(host, _tld_length = nil)
    extract_subdomain(host)
  end

  def self.rules_from_psl_file
    PublicSuffixList.new(File.join(__dir__, "..", "psl", "public_suffix_list.dat")).rules
  end
  private_class_method :rules_from_psl_file
end
