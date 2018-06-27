class UsersController < ApplicationController
  layout "authentication", only: [:new, :create]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      flash[:success] = "Successfully created an account!"
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:error] = "Error in creating account."
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end