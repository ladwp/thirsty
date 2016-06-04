module AqueductCrawler
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
  class SampleParser
    attr :sampled_at, :value
    def initialize(sample_row)

      sampled_at_el = sample_row.children[0]
      raise ParseError.new("can't find sampled_at element") if sampled_at_el.nil?
      sampled_at_text = sampled_at_el.inner_text.strip

      begin
        # datetimes like "08/31/12 12:28:52 PM"
        @sampled_at = Time.strptime(sampled_at_text + " PDT", "%m/%d/%y %I:%M:%S %p %z")
      rescue ArgumentError => e
        raise ParseError.new("Failed to parse sampled_at_text: #{sampled_at_text} with error: #{e}")
      end

      value_el = sample_row.children[1]
      raise ParseError.new("can't find value element") if value_el.nil?
      @value = value_el.inner_text.strip.to_f

      @site_id = @site_id
    end

    def to_hash
      {
        :sampled_at => @sampled_at,
        :value => @value
      }
    end
  end
end
