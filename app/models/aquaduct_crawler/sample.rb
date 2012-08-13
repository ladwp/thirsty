module AquaductCrawler
  class Sample
    attr :site_id, :value, :sampled_at, :type

    def initialize(params)\
      @site_id = params[:site_id]
      @value = params[:value]
      @sampled_at = params[:sampled_at]
      @type = params[:type]
    end

    def ==(other_sample)
      [:site_id, :value, :sampled_at].inject(true) do |equals, attribute|
        equals && (send(attribute) == other_sample.send(attribute))
      end
    end
  end
end
