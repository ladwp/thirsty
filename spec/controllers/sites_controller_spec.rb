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
      Site.should_receive(:find).with('1').and_return(mock_model(Site))
      get :show, :id => 1
    end
  end
end
