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
  end
end
