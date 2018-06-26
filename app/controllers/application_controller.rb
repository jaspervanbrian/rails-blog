class ApplicationController < ActionController::Base
  def confirm_authenticated
    unless session[:user_id]
      flash[:error] = "Please log in first."
      redirect_to login_path
    end
  end
  
  def is_logged_in
    unless session[:user_id].nil?
      redirect_to root_path
    end
  end
end
