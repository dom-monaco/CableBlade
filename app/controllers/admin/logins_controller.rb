class Admin::LoginsController < Admin::BaseController
  skip_before_action :require_login

  def create
    user = User.find_by(email: params[:email])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      redirect_to admin_networks_path
    else
      flash.now[:danger] = 'Log in failed.'
      render 'new'
    end
  end

end
