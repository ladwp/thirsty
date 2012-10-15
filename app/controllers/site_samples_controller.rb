class SiteSamplesController < ApplicationController
  def index
    @samples = Site.find(params[:site_id]).samples
    @samples = @samples.where("sampled_at > ?", params[:sampled_after]) if params[:sampled_after]
    @samples = @samples.where("sampled_at < ?", params[:sampled_before]) if params[:sampled_before]

    respond_to do |format|
      format.json { render :json => @samples }
    end
  end
end
