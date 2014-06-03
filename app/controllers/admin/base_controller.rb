Class Admin::BaseController < ApplicationController
  layout 'admin'

  def logged_in?
    session[:user_id].present?
  end

  def require_login
    unless logged_in?
      redirect_to admin_login_path, danger: 'Please log in to continue.'
    end
  end

end
