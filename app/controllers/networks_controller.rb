class NetworksController < ApplicationController

  # GET /networks
  # GET /networks.json
  def index
    @networks = Network.all
  end
end
