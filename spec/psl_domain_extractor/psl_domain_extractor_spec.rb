describe PslDomainExtractor do
  subject { described_class }

  describe ".extract_domain" do
    it "extracts the domain from a full domain" do
      expect(subject.extract_domain("www.example.com")).to eq("example.com")
      expect(subject.extract_domain("subdomain.example.co.uk")).to eq("example.co.uk")
      expect(subject.extract_domain("example.org")).to eq("example.org")
    end

    it "returns nil for invalid domains" do
      expect(subject.extract_domain(nil)).to be_nil
      expect(subject.extract_domain("")).to be_nil
      expect(subject.extract_domain(".")).to be_nil
      expect(subject.extract_domain("..")).to be_nil
      expect(subject.extract_domain("invalid..domain.com")).to be_nil
    end

    it "handles internationalized domain names (IDNs)" do
      expect(subject.extract_domain("xn--fsq.com")).to eq("xn--fsq.com") # IDN for "例子.com"
      expect(subject.extract_domain("例子.公司.cn")).to eq("例子.公司.cn")
    end

    it "is case insensitive" do
      expect(subject.extract_domain("WWW.Example.COM")).to eq("example.com")
      expect(subject.extract_domain("SubDomain.Example.Co.Uk")).to eq("example.co.uk")
    end

    it "handles domains with leading and trailing dots" do
      expect(subject.extract_domain(".www.example.com.")).to eq("example.com")
      expect(subject.extract_domain(".example.org")).to eq("example.org")
      expect(subject.extract_domain("example.org.")).to eq("example.org")
    end

    it "handles domains with multiple subdomains" do
      expect(subject.extract_domain("a.b.c.d.example.com")).to eq("example.com")
      expect(subject.extract_domain("x.y.z.subdomain.example.co.uk")).to eq("example.co.uk")
    end

    it "handles domains with uncommon TLDs" do
      expect(subject.extract_domain("example.tech")).to eq("example.tech")
      expect(subject.extract_domain("subdomain.example.travel")).to eq("example.travel")
    end

    it "handles wildcard rules in the public suffix list" do
      expect(subject.extract_domain("a.b.ck")).to eq("a.b.ck") # .ck has a wildcard rule
      expect(subject.extract_domain("a.b.www.ck")).to eq("www.ck")
    end

    it "handles exception rules in the public suffix list" do
      expect(subject.extract_domain("www.city.kawasaki.jp")).to eq("city.kawasaki.jp") # Exception rule
      expect(subject.extract_domain("sub.city.kawasaki.jp")).to eq("city.kawasaki.jp")
    end
  end

  describe ".extract_subdomain" do
    it "extracts the subdomain from a full domain" do
      expect(subject.extract_subdomain("www.example.com")).to eq("www")
      expect(subject.extract_subdomain("subdomain.example.co.uk")).to eq("subdomain")
      expect(subject.extract_subdomain("example.org")).to be_nil
    end

    it "returns nil for invalid domains" do
      expect(subject.extract_subdomain(nil)).to be_nil
      expect(subject.extract_subdomain("")).to be_nil
      expect(subject.extract_subdomain(".")).to be_nil
      expect(subject.extract_subdomain("..")).to be_nil
      expect(subject.extract_subdomain("invalid..domain.com")).to be_nil
    end

    it "handles internationalized domain names (IDNs)" do
      expect(subject.extract_subdomain("xn--fsq.com")).to be_nil # IDN for "例子.com"
      expect(subject.extract_subdomain("例子.公司.cn")).to be_nil
    end

    it "is case insensitive" do
      expect(subject.extract_subdomain("WWW.Example.COM")).to eq("www")
      expect(subject.extract_subdomain("SubDomain.Example.Co.Uk")).to eq("subdomain")
    end

    it "handles domains with leading and trailing dots" do
      expect(subject.extract_subdomain(".www.example.com.")).to eq("www")
      expect(subject.extract_subdomain(".example.org")).to be_nil
      expect(subject.extract_subdomain("example.org.")).to be_nil
    end

    it "handles domains with multiple subdomains" do
      expect(subject.extract_subdomain("a.b.c.d.example.com")).to eq("a.b.c.d")
      expect(subject.extract_subdomain("x.y.z.subdomain.example.co.uk")).to eq("x.y.z.subdomain")
    end

    it "handles domains with uncommon TLDs" do
      expect(subject.extract_subdomain("example.tech")).to be_nil
      expect(subject.extract_subdomain("subdomain.example.travel")).to eq("subdomain")
    end

    it "handles wildcard rules in the public suffix list" do
      expect(subject.extract_subdomain("a.b.ck")).to be_nil # .ck has a wildcard rule
      expect(subject.extract_subdomain("a.b.www.ck")).to eq("a.b")
    end

    it "handles exception rules in the public suffix list" do
      expect(subject.extract_subdomain("www.city.kawasaki.jp")).to eq("www") # Exception rule
      expect(subject.extract_subdomain("sub.city.kawasaki.jp")).to eq("sub")
    end
  end

  describe ".extract_public_suffix" do
    it "extracts the domain from a full domain" do
      expect(subject.extract_public_suffix("www.example.com")).to eq("com")
      expect(subject.extract_public_suffix("subdomain.example.co.uk")).to eq("co.uk")
      expect(subject.extract_public_suffix("example.org")).to eq("org")
    end

    it "returns nil for invalid domains" do
      expect(subject.extract_public_suffix(nil)).to be_nil
      expect(subject.extract_public_suffix("")).to be_nil
      expect(subject.extract_public_suffix(".")).to be_nil
      expect(subject.extract_public_suffix("..")).to be_nil
      expect(subject.extract_public_suffix("invalid..domain.com")).to be_nil
    end

    it "handles internationalized domain names (IDNs)" do
      expect(subject.extract_public_suffix("xn--fsq.com")).to eq("com") # IDN for "例子.com"
      expect(subject.extract_public_suffix("例子.公司.cn")).to eq("公司.cn")
    end

    it "is case insensitive" do
      expect(subject.extract_public_suffix("WWW.Example.COM")).to eq("com")
      expect(subject.extract_public_suffix("SubDomain.Example.Co.Uk")).to eq("co.uk")
    end

    it "handles domains with leading and trailing dots" do
      expect(subject.extract_public_suffix(".www.example.com.")).to eq("com")
      expect(subject.extract_public_suffix(".example.org")).to eq("org")
      expect(subject.extract_public_suffix("example.org.")).to eq("org")
    end

    it "handles domains with multiple subdomains" do
      expect(subject.extract_public_suffix("a.b.c.d.example.com")).to eq("com")
      expect(subject.extract_public_suffix("x.y.z.subdomain.example.co.uk")).to eq("co.uk")
    end

    it "handles domains with uncommon TLDs" do
      expect(subject.extract_public_suffix("example.tech")).to eq("tech")
      expect(subject.extract_public_suffix("subdomain.example.travel")).to eq("travel")
    end

    it "handles wildcard rules in the public suffix list" do
      expect(subject.extract_public_suffix("a.b.ck")).to eq("b.ck") # .ck has a wildcard rule
      expect(subject.extract_public_suffix("a.b.www.ck")).to eq("ck")
    end

    it "handles exception rules in the public suffix list" do
      expect(subject.extract_public_suffix("www.city.kawasaki.jp")).to eq("kawasaki.jp") # Exception rule
      expect(subject.extract_public_suffix("sub.city.kawasaki.jp")).to eq("kawasaki.jp")
    end
  end
end
