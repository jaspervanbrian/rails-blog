class UsersController < ApplicationController
  layout "authentication", only: [:new, :create]
  before_action :vars_init, except: [:new, :create]

  def show
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

    @user.profile_avatar.attach(user_params[:profile_avatar])
    if @user.valid?(:update_profile_avatar)
      if @user.save(context: :update_profile_avatar)
        flash[:success] = "Your profile avatar was successfully updated!"
        redirect_to user_path(@user)
      else
        flash.now[:error] = "There was error updating your profile avatar."
        render :show
      end
    else
      flash.now[:error] = "There was error updating your profile avatar."
      render :show
    end
  end

  def update_photo_banner

    @user.profile_banner.attach(user_params[:profile_banner])
    if @user.valid?(:update_profile_banner)
      if @user.save(context: :update_profile_banner)
        flash[:success] = "Your profile banner was successfully updated!"
        redirect_to user_path(@user)
      else
        flash.now[:error] = "There was error updating your profile banner."
        render :show
      end
    else
      flash.now[:error] = "There was error updating your profile banner."
      render :show
    end
  end

  def update_password
    authorized = false

    if params[:user][:old_password].present? && params[:user][:password].present? && params[:user][:password_confirmation].present?
      authorized = @user.authenticate(params[:user][:old_password])
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

  def vars_init
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.latest.page(params[:page])
    @post = Post.new
    if helpers.logged_in?
      @conversation = Conversation.new
      @conversationsUsers = ConversationsUser.where(user_id: [@user.id, session[:user_id]])
      @conversationsUsers.each do |conversationUser|
        conversation = conversationUser.conversation
        users = conversation.users # users of this conversation
        if conversation.name.nil? && (users.length === 2) && ((users.include?(@user.id) && users.include?(session[:user_id]))) # Checks if the conversation has only 2 users (You and your friend) and the default is no conversation name because it uses your friends name as convo name
          @conversation = conversation
        end
      end
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :profile_avatar, :profile_banner, :new_password)
  end
end