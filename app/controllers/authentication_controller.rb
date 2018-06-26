class AuthenticationController < ApplicationController
  before_action :confirm_authenticated, only: [:logout]

  layout "authentication"

  def login

  end

  def attempt
    authorized = false
    if params[:email].present? && params[:password].present?
      user = User.find_by(email: params[:email])
      if user
        authorized = user.authenticate(params[:password])
      end
    end

    if authorized
      session[:user_id] = authorized.id
      flash[:success] = "You are now logged in!"
      redirect_to root_path
    else
      flash.now[:error] = "Invalid login credentials."
      render :login
    end
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Logged out."
    redirect_to login_path
  end

  private 
  
  def confirm_authenticated
    unless session[:user_id]
      flash[:error] = "Please log in first."
      redirect_to login_path
    end
  end
end
