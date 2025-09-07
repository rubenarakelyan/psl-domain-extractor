# PSL Domain Extractor

[![Gem Version](https://badge.fury.io/rb/psl-domain-extractor.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/psl-domain-extractor)

This gem provides methods for extracting domains, subdomains and public suffixes from hostnames using the [Public Suffix List](https://publicsuffix.org).

Note this repository contains a submodule in `psl`. To clone the repository, run `git clone --recurse-submodules https://github.com/rubenarakelyan/psl-domain-extractor`.

## Concepts

A `hostname` is what you provide to this gem. For example, `www.example.com` is a hostname. You can then extract the `domain`, `subdomain` or `public suffix`.

A `label` is one part of a `hostname` separated by a dot. For example, the labels for `www.example.com` are `www`, `example` and `com`.

The `domain` is the part of the hostname that is registrable. For example, the domain for `www.example.com` is `example.com` because you could register `example.com` with a domain registrar.

The `subdomain` is the part of the hostname that is under the control of the domain’s registrant. For example, the subdomain for `www.example.com` is `www` because as the registrant for `example.com`, you control `www`. Note that a subdomain may contain multiple labels. For example, the subdomain for `foo.bar.example.com` is `foo.bar`, which is made up of two labels, `foo` and `bar`.

The `public suffix` is the part of the hostname that is allocated to the domain registry and hence not registrable. For example, the `public suffix` for `www.example.com` is `com`. `com` is allocated to the domain registry (in this case, Verisign) and you cannot register it. The `public suffix` is always one level below the `domain`. For example, `co.uk` and `uk` are both a `public suffix` because you can register `example.co.uk` and `example.uk`, but not `co.uk` or `uk`.

### Important note on multi-tenant domains

The actual rules for the public suffix list are more complex than this since they also include wildcards, exceptions, and private multi-tenant domains. This gem takes all those into consideration. For example, Netlify has registered `netlify.app` as a domain name to host apps from multiple customers. `netlify.app` is in the public suffix list. Therefore, even though `netlify.app` is a registrable domain, in this case it is considered the public suffix. A customer’s app at `bar.netlify.app` would be considered the domain (in a sense, this has been registered with Netlify), and for `foo.bar.netlify.app`, the subdomain would be `foo` (not `foo.bar`).

## Getting started

Add to your `Gemfile` then run `bundle install`:

```ruby
gem "psl-domain-extractor"
```

or install using `gem`:

```bash
gem install psl-domain-extractor
```

## Using with plain Ruby

Extract the domain:

```ruby
PslDomainExtractor.extract_domain(domain)
```

Extract the subdomain:

```ruby
PslDomainExtractor.extract_subdomain(domain)
```

Extract the public suffix:

```ruby
PslDomainExtractor.extract_public_suffix(domain)
```

## Using with a Rails app as the default domain extractor

Add the following to your Rails configuration:

```ruby
config.action_dispatch.domain_extractor = PslDomainExtractor
```

`request.domain` and `request.subdomain` will then be set using this gem’s logic.

Of course if you don’t want to change the default logic for domain extraction, you can always call the gem’s standalone methods as required in your app.

## Note on gem signing and verification

This gem is cryptographically signed. To be sure the gem you install hasn’t been tampered with, run:
```bash
gem cert --add <(curl -Ls https://raw.github.com/rubenarakelyan/psl-domain-extractor/main/certs/rubena.pem)
gem install psl-domain-extractor -P MediumSecurity
```

The `MediumSecurity` trust profile will verify signed gems, but allow the installation of unsigned dependencies.

This is necessary because not all of this gem’s dependencies are signed, so we cannot use `HighSecurity`.

## Licence

This gem is licensed under the [MIT licence](LICENSE).
