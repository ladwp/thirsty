require 'spec_helper'

describe SiteSamplesController do
  describe "index" do
    let(:mock_site) { mock_model(Site) }

    it "should render the sites samples as json" do
      Site.should_receive(:find).with('1').and_return(mock_site)
      mock_site.should_receive(:samples)

      get :index, :site_id => '1', :format => :json
    end

    it "should return 404 if site doesn't exist" do
      expect {
        get :index, :site_id => '678', :format => :json
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    describe "filtering by date" do
      let(:mock_site) { mock_model(Site, :samples => double('site_samples')) }
      let(:samples_query) { double('samples_query') }
      before do
        Site.should_receive(:find).with('1').and_return(mock_site)
        mock_site.samples.stub(:as_json)
      end
      it "should filter samples by 'before' date" do
        mock_site.samples.should_receive(:where).with("sampled_at < ?", Date.parse("December 1, 2012"))

        get :index, :site_id => '1', :format => :json, :sampled_before => Date.parse("December 1, 2012").to_json
      end
      it "should filter samples by 'after' date" do
        mock_site.samples.should_receive(:where).with("sampled_at > ?", Date.parse("December 1, 2012"))

        get :index, :site_id => '1', :format => :json, :sampled_after => Date.parse("December 1, 2012").to_json
      end
      it "should filter samples by 'before' and 'after' dates" do
        mock_site.samples.should_receive(:where).with("sampled_at > ?", Date.parse("June 1, 2012")).and_return(samples_query)
        samples_query.should_receive(:where).with("sampled_at < ?", Date.parse("December 1, 2012"))

        get :index, :site_id => '1', :format => :json, :sampled_before => Date.parse("December 1, 2012").to_json, :sampled_after => Date.parse("June 1, 2012").to_json
      end
    end
  end
end
