FactoryGirl.define do
  factory :sample do
    value { Kernel.rand }
    sampled_at { 4.hours.ago }
  end
end
