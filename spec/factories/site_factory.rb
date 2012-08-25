FactoryGirl.define do
  factory :site do
    sequence(:site_name, 1000) { |n| "site #{n}" }
    measurement_type "Flow"
  end
end
