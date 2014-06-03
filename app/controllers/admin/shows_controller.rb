class Admin::ShowsController < Admin::BaseController
  def index
    @shows = Show.order('name')
  end

  def show
    @show = Show.find_by(params[:id])
  end

  def new
    @show = Show.new
  end

  def create
    @show = Show.new(show_params)
    if @show.save
      redirect_to admin_shows_path, success: "Show ID #{@show.id} was created."
    else
      render 'new'
    end
  end

  def edit
    @show = Show.find(params[:id])
  end

  def update
    @show = Show.find(params[:id])
    if @show.update(show_params)
      redirect_to admin_shows_path,  success: "Show ID #{@show.id} was updated."
    else
      render 'edit'
    end
  end

  def destroy
    @show = Show.find(params[:id])
    if @show.destroy
      flash[:success] = "Show deleted."
    else
      flash[:danger] = "Show could not be deleted."
    end
    redirect_to admin_shows_path
  end

  protected
    def show_params
      params.require(:show).permit(:name, :image)
    end

end
