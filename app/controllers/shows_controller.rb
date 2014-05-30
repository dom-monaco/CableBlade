class ShowsController < ApplicationController

  # GET /shows
  # GET /shows.json
  def index
    if params[:networks].present?
      @shows = Show.where(network: params[:networks])
    else
      @shows = Show.all
    end
  end
end
