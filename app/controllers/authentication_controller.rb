class AuthenticationController < ApplicationController
  before_action :confirm_authenticated, only: [:logout]
  before_action :is_logged_in, only: [:login, :attempt]

  layout "authentication"

  def login
    @user = User.new
  end

  def attempt
    authorized = false
    if params[:email].present? && params[:password].present?
      user = User.find_by(email: params[:email].downcase)
      if user
        authorized = user.authenticate(params[:password])
      end
    end

    if authorized # checks if user is already authorized
      helpers.log_in authorized
      params[:remember_me] == '1' ? helpers.remember(authorized) : helpers.forget(authorized)
      redirect_to root_path
    else
      flash.now[:error] = "Invalid login credentials."
      render :login
    end
  end

  def logout
    helpers.log_out if helpers.logged_in? # Only logs out if a user is signed in.
    redirect_to login_path
  end

end
