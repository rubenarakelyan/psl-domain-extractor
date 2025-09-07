module PslDomainExtractor
  class Extractors
    def initialize(rules)
      @rules = rules
    end

    def extract_domain(domain)
      domain = normalize_domain(domain)
      return if domain.nil?

      labels = domain.split(".")
      find_match(labels, labels.length, effective_domain: true)
    end

    def extract_subdomain(domain)
      domain = normalize_domain(domain)
      return if domain.nil?

      labels = domain.split(".")
      effective_domain = find_match(labels, labels.length, effective_domain: true)
      effective_domain = domain.gsub(/(\.)?#{effective_domain}/, "")

      effective_domain.empty? ? nil : effective_domain
    end

    def extract_public_suffix(domain)
      domain = normalize_domain(domain)
      return if domain.nil?

      labels = domain.split(".")
      find_match(labels, labels.length)
    end

    private

    def normalize_domain(domain)
      return if domain.nil? || domain.empty?

      domain = domain.downcase.gsub(/(^\.)|(\.$)/, "")
      return if domain.include?("..") || domain.empty?

      domain
    end

    def find_match(labels, pos, effective_domain: false)
      return if pos < 1

      suffix_labels = labels[-pos, pos]
      suffix = suffix_labels.join(".")

      if @rules.include?("!#{suffix}")
        return labels[-(pos - 1), pos + 1]&.join(".") || suffix unless effective_domain
        return suffix if effective_domain
      end

      match = @rules.include?(suffix) ||
              (pos > 1 && @rules.include?("*.#{suffix_labels[1, pos - 1].join('.')}"))
      return suffix if (match || pos == 1) && !effective_domain
      return labels[-(pos + 1), pos + 1]&.join(".") || suffix if (match || pos == 1) && effective_domain

      find_match(labels, pos - 1, effective_domain:)
    end
  end
end
