class UsersController < ApplicationController
  layout "authentication", only: [:new, :create]

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.latest.page(params[:page])
    @post = Post.new
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

  def update
    authorized = false
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.latest.page(params[:page])
    @post = Post.new

    if params[:password].present?
      authorized = user.authenticate(params[:password])
    end

    if authorized
      if @user.update_attributes(user_params)
        flash[:success] = "Your profile details was successfully updated!"
        redirect_to user_path(@user)
      else
        flash.now[:error] = "There was error updating your profile details."
        flash.now[:error_user_details] = "Invalid details/password."
        render :show
      end
    else
      flash.now[:error] = "There was error updating your profile details."
      flash.now[:error_user_details] = "Invalid details/password."
      render :show
    end
  end

  def update_photo_avatar
    authorized = false
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.latest.page(params[:page])
    @post = Post.new

    if params[:password].present?
      authorized = user.authenticate(params[:password])
    end

    if authorized
      if @user.update_attributes(user_params)
        flash[:success] = "Your profile avatar was successfully updated!"
        redirect_to user_path(@user)
      else
        flash.now[:error] = "There was error updating your profile avatar."
        flash.now[:error_user_avatar] = "Invalid password."
        render :show
      end
    else
      flash.now[:error] = "There was error updating your profile avatar."
      flash.now[:error_user_avatar] = "Invalid password."
      render :show
    end
  end

  def update_photo_banner
    authorized = false
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.latest.page(params[:page])
    @post = Post.new

    if params[:password].present?
      authorized = user.authenticate(params[:password])
    end

    if authorized
      if @user.update_attributes(user_params)
        flash[:success] = "Your profile banner was successfully updated!"
        redirect_to user_path(@user)
      else
        flash.now[:error] = "There was error updating your profile banner."
        flash.now[:error_user_banner] = "Invalid password."
        render :show
      end
    else
      flash.now[:error] = "There was error updating your profile banner."
      flash.now[:error_user_banner] = "Invalid password."
      render :show
    end
  end

  def update_password
    authorized = false
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.latest.page(params[:page])
    @post = Post.new

    if params[:old_password].present? && params[:password].present? && params[:password_confirmation].present?
      authorized = user.authenticate(params[:old_password])
    end

    if authorized
      if params[:user][:password] === params[:user][:password_confirmation]
        if @user.update_attributes(user_params)
          flash[:success] = "Your password was successfully updated!"
          redirect_to user_path(@user)
        else
          flash.now[:error] = "There was error updating your password."
          flash.now[:error_user_password] = "Invalid password."
          render :show
        end
      else
        flash.now[:error] = "There was error updating your password."
        flash.now[:error_user_password] = "Invalid password."
        render :show
      end
    else
      flash.now[:error] = "There was error updating your password."
      flash.now[:error_user_password] = "Invalid password."
      render :show
    end
  end


  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :profile_avatar, :profile_banner, :new_password)
  end
end