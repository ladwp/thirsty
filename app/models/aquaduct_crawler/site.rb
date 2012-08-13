# A "site" is a collection point for samples. 
# I think this corresponds to a sensor
module AquaductCrawler
  class Site
    attr :body, :id, :site_name, :measurement_type

    def initialize(filename)
      @filename = filename
      @response = Net::HTTP.get(HOST, BASE_PATH + @filename)
      @body = Nokogiri::HTML::DocumentFragment.parse(@response)
      @id, _ = filename.split(".")
      @measurement_type = MEASUREMENT_TYPES.detect { |type| header.include?(type) }
      if @measurement_type.nil?
        AquaductCrawler.logger.warn("Unknown type for #{header} (#{filename}), assuming 'Flow'")
        @measurement_type = 'Flow' 
      end
      @site_name = header.gsub(/ #{@measurement_type}$/,'')
    end

    def header
      @body.at("div b").inner_text
    end

    def measurements
      @body.at('table').children[3..-1].map do |sample_row|
        Sample.new(
          :site_id => @id,
          :sampled_at => DateTime.parse(sample_row.children[0].inner_text.strip),
          :value => sample_row.children[1].inner_text.strip.to_f,
          :type => @measurement_type
        )
      end
    end
  end
end
