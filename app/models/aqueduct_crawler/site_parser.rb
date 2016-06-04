require 'aqueduct_crawler'

module AqueductCrawler
  class SiteParser
    attr :body, :id, :site_name, :measurement_type

    def initialize(filename)
      @filename = filename
      @response = Net::HTTP.get(HOST, BASE_PATH + @filename)
      @body = Nokogiri::HTML::DocumentFragment.parse(@response)
      @id, _ = filename.split(".")
      @measurement_type = MEASUREMENT_TYPES.detect { |measurement_type| header.include?(measurement_type) }
      if @measurement_type.nil?
        AqueductCrawler.logger.warn("Unknown measurement_type for #{header} (#{filename}), assuming 'Flow'")
        @measurement_type = FLOW
      end
      @site_name = header.gsub(/ #{@measurement_type}$/,'')
    end

    def header
      header_el = @body.at("div b")
      raise ParseError.new("Cannot find header") if header_el.nil?

      header_el.inner_text
    end

    def sample_parses
      @body.at('table').children[3..-1].map do |sample_row|
        begin
          sample_parse = SampleParser.new(sample_row)
        rescue ParseError => e
          AqueductCrawler.logger.info("Failed to parse sample for site:#{id} with error: #{e}")
        end
        sample_parse
      end.compact
    end

    def to_hash
      {
        :id => @id,
        :measurement_type => @measurement_type,
        :site_name => @site_name
      }
    end

  end
end
