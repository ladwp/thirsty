require 'spec_helper'

module AqueductCrawler
  describe ".update_samples" do
    let(:site_id) { "001" }
    before do
      stub_request(:get, "http://wsoweb.ladwp.com/Aqueduct/realtime/").
         with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => File.read('spec/fixtures/fake_index.html'), :headers => {})

      stub_request(:get, "http://wsoweb.ladwp.com/Aqueduct/realtime/#{site_id}.htm").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => File.read('spec/fixtures/fake_feed.html'), :headers => {})
    end

    it "should add sites and samples" do
      Sample.count.should == 0
      Site.count.should == 0

      AqueductCrawler.update_samples

      Sample.count.should == 5
      Site.count.should == 1
    end

    context "when some samples already exist" do
      it "should only add new samples" do
        site = FactoryGirl.create(:site, :id => site_id)
        FactoryGirl.create(:sample, :sampled_at => Time.parse("Aug 6, 2012 7:44:24 PM PDT"), :value => 0.0, :site => site)
        Sample.count.should == 1

        AqueductCrawler.update_samples

        Sample.count.should == 5
      end
    end

    context "when there are no new samples" do
      it "should send an email" do
        AqueductCrawler.update_samples
        expect { AqueductCrawler.update_samples_with_notification }.to change { ActionMailer::Base.deliveries.count }.by(1)
        ActionMailer::Base.deliveries[0].body.encoded.should start_with('Hey - the following')
      end
    end

    context "when there are some new samples" do
      it "should not send an email" do
        expect { AqueductCrawler.update_samples_with_notification }.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end
