module AquaductCrawler
  class Sample < ActiveRecord::Base
    class Parse
      attr :sampled_at, :value
      def initialize(sample_row)
        begin
          # datetimes like "08/31/12 12:28:52 PM"
          @sampled_at = Time.strptime(sample_row.children[0].inner_text.strip, "%m/%d/%y %I:%M:%S %p")
          @value = sample_row.children[1].inner_text.strip.to_f
        rescue
          require 'ruby-debug'; debugger
          p site_parse
        end
      end
    end

    attr_accessible :id, :created_at, :updated_at, :site_id, :value, :sampled_at

    belongs_to :site

    delegate :measurement_type, :to => :site

    def ==(other_sample)
      [:site_id, :value, :sampled_at].inject(true) do |equals, attribute|
        equals && (send(attribute) == other_sample.send(attribute))
      end
    end
  end
end
