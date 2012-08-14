module AquaductCrawler
  class Sample < ActiveRecord::Base
    # ladwp stores last 5 days of sample data
    # Today's samples are stored in 15 minute increments,
    # the previous four days are stored in one hour increments
    #
    # Also, it seems like there is a gap in the readings "this morning"
    # 08/13/12 11:29:16 AM	 5.7
    # 08/13/12 11:14:16 AM	 5.7
    # 8/12/12 11:44:16 PM	 5.0
    # 8/12/12 10:44:16 PM	 5.0
    # 8/12/12 9:44:16 PM	 5.0
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
