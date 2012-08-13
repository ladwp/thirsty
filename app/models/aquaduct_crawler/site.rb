# A "site" is a collection point for samples. 
# I think this corresponds to a sensor
module AquaductCrawler
  class Site < ActiveRecord::Base
    attr_accessible :id, :site_name, :measurement_type

    class Parse
      attr :body, :id, :site_name, :measurement_type

      def initialize(filename)
        @filename = filename
        @response = Net::HTTP.get(HOST, BASE_PATH + @filename)
        @body = Nokogiri::HTML::DocumentFragment.parse(@response)
        @id, _ = filename.split(".")
        @measurement_type = MEASUREMENT_TYPES.detect { |measurement_type| header.include?(measurement_type) }
        if @measurement_type.nil?
          AquaductCrawler.logger.warn("Unknown measurement_type for #{header} (#{filename}), assuming 'Flow'")
          @measurement_type = FLOW
        end
        @site_name = header.gsub(/ #{@measurement_type}$/,'')
      end

      def header
        @body.at("div b").inner_text
      end

      def samples
        @body.at('table').children[3..-1].map do |sample_row|
          sample_parse = Sample::Parse.new(sample_row)
          Sample.new(
            :site_id => @id,
            :sampled_at => sample_parse.sampled_at,
            :value => sample_parse.value
          )
        end
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
end
