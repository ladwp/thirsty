class SitesController < ApplicationController
  def index
    @sites = AquaductCrawler::Site.all
    respond_to do |format|
      format.html
      format.json { render :json => @sites }
    end
  end

  def show
    @site = AquaductCrawler::Site.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => @site.as_json(:include => :samples) }
    end
  end
end
