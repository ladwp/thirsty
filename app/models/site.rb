# A "site" is a collection point for samples. 
# I think this corresponds to a sensor
class Site < ActiveRecord::Base
  attr_accessible :id, :site_name, :measurement_type

  has_many :samples

end


