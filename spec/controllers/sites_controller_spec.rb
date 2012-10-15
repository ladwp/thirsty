require 'spec_helper'

describe SitesController do
  describe "#index" do
    it "shouldn't explode" do
      get :index
    end
    it "should support json" do
      get :index, :format => :json
    end
  end
  describe "#show" do
    it "shouldn't explode" do
      Site.stub_chain(:with_last_sampled_at, :find).and_return(mock_model(Site))
      get :show, :id => 1
    end
    it "should support json" do
      mock_site = mock_model(Site)
      mock_site.should_receive(:as_json).and_return({ :some => 'data' })
      Site.stub_chain(:with_last_sampled_at, :find).and_return(mock_site)

      get :show, :id => 1, :format => :json
    end
  end
end
