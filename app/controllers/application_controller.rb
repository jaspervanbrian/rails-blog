class ApplicationController < ActionController::Base
  def confirm_authenticated
    unless helpers.logged_in?
      flash[:error] = "Please log in first."
      redirect_to login_path
    end
  end
  
  def is_logged_in
    unless !helpers.logged_in?
      redirect_to root_path
    end
  end
end
