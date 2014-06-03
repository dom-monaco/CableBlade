class Admin::NetworksController < Admin::BaseController
  def index
    @networks = Network.order('name')
  end

  def show
    @network = Network.find_by(params[:id])
  end

  def new
    @network = Network.new
  end

  def create
    @network = Network.new(network_params)
    if @network.save
      redirect_to admin_networks_path, success: "Network ID #{@network.id} was created."
    else
      render 'new'
    end
  end

  def edit
    @network = Network.find(params[:id])
  end

  def update
    @network = Network.find(params[:id])
    if @network.update(network_params)
      redirect_to admin_networks_path,  success: "Network ID #{@network.id} was updated."
    else
      render 'edit'
    end
  end

  def destroy
    @network = Network.find(params[:id])
    if @network.destroy
      flash[:success] = "Network deleted."
    else
      flash[:danger] = "Network could not be deleted."
    end
    redirect_to admin_networks_path
  end

  protected
    def network_params
      params.require(:network).permit(:name, :image)
    end

end
