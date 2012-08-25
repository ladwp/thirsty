class Sample < ActiveRecord::Base
  attr_accessible :id, :created_at, :updated_at, :site_id, :value, :sampled_at

  validates_presence_of :value, :sampled_at, :site

  belongs_to :site

  delegate :measurement_type, :to => :site

  def ==(other_sample)
    [:site_id, :value, :sampled_at].inject(true) do |equals, attribute|
      equals && (send(attribute) == other_sample.send(attribute))
    end
  end
end

