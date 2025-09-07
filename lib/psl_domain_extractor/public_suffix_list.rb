module PslDomainExtractor
  class PublicSuffixList
    attr_reader :rules

    def initialize(file_path)
      @rules = Set.new
      File.open(file_path, "r:utf-8") do |f|
        f.each_line do |line|
          line = line.strip
          next if line.empty? || line.start_with?("//")

          @rules.add(line)
        end
      end
    end
  end
end
