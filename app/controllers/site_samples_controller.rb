class SiteSamplesController < ApplicationController
  def index
    @samples = Site.find(params[:site_id]).samples

    if params[:sampled_after].present?
      @sampled_after = Date.parse(params[:sampled_after])
    end
    if params[:sampled_before].present?
      @sampled_before = Date.parse(params[:sampled_before])
    end

    @samples = @samples.where("sampled_at > ?", @sampled_after) if @sampled_after
    @samples = @samples.where("sampled_at < ?", @sampled_before) if @sampled_before

    result = { samples: @samples,
               sampled_after: @sampled_after,
               sampled_before: @sampled_before }

    respond_to do |format|
      format.json { render :json => result }
    end
  end
end
