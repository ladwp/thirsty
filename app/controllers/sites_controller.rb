class SitesController < ApplicationController
  def index
    @sites = AquaductCrawler::Site.all
    render :json => @sites
  end

  def show
    @site = AquaductCrawler::Site.find(params[:id])
    render :json => @site.as_json(:include => :samples)
  end
end
