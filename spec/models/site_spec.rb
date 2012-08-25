require 'spec_helper'

describe Site do
  describe ".with_last_sampled_at" do
    it "should add a field to sites including the sample date of their last sample", :speed => :slow do
      #save time for comparison
      an_hour_ago = 1.hour.ago
      yesterday = 1.day.ago
      a_while_back = 3.days.ago

      site_with_two_samples = FactoryGirl.create(:site)
      new_sample = FactoryGirl.create(:sample, :site => site_with_two_samples, :sampled_at => an_hour_ago)
      old_sample = FactoryGirl.create(:sample, :site => site_with_two_samples, :sampled_at => yesterday)

      single_sample_site = FactoryGirl.create(:site)
      single_sample = FactoryGirl.create(:sample, :site => single_sample_site, :sampled_at => a_while_back)

      site_with_no_samples = FactoryGirl.create(:site)

      sites_with_last_sampled_at = Site.with_last_sampled_at
      sites_with_last_sampled_at.detect { |site| site == site_with_two_samples }.last_sampled_at.to_s.should == an_hour_ago.to_s
      sites_with_last_sampled_at.detect { |site| site == single_sample_site }.last_sampled_at.to_s.should == a_while_back.to_s
      sites_with_last_sampled_at.detect { |site| site == site_with_no_samples }.last_sampled_at.should be_nil
    end
  end
end
