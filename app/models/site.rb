# A "site" is a collection point for samples. 
# I think this corresponds to a sensor
class Site < ActiveRecord::Base
  attr_accessible :id, :site_name, :measurement_type

  has_many :samples

  validates_presence_of :site_name, :measurement_type

  scope :with_last_sampled_at, select("sites.*, last_sampled_at").
                               joins("LEFT OUTER JOIN (SELECT site_id, MAX(sampled_at) AS last_sampled_at 
                                        FROM samples 
                                        GROUP BY site_id) latest_site_samples
                                      ON sites.id = latest_site_samples.site_id")

  def last_sampled_at
    raise "Missing attribute" unless has_attribute?(:last_sampled_at)
    Time.zone.parse(read_attribute(:last_sampled_at) + " UTC") unless read_attribute(:last_sampled_at).nil?
  end

  def last_sample
    samples.order(:updated_at).last
  end

end


