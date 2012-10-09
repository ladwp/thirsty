class SiteSamplesController < ApplicationController
  def index
    @samples = Site.find(params[:site_id]).samples
    respond_to do |format|
      format.json { render :json => @samples }
    end
  end
end
