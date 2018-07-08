class PostsController < ApplicationController
  before_action :get_posts, only: [:index, :create]
  before_action :confirm_authenticated, except: [:index, :show]
  before_action :confirm_post_ownership, only: [:edit, :update, :destroy]

  def index
    @post = Post.new
  end

  def show
    @post = Post.find_by(id: params[:id])
    if @post.attachments.present?
      @attachments = @post.attachments
    end
    @comment = Comment.new
  end

  def create
    @post = Post.new(posts_params)
    @user = User.find_by(id: session[:user_id])
    unless @user.nil?
      @user.posts << @post
      if @post.valid?
        flash[:success] = "Successfully posted a content!"
        if params[:user_id].present? # if request came from profile page
          redirect_to user_path(@user)
        else
          redirect_to :action => 'index'
        end
      else
        flash.now[:error] = "Error posting content."
        if params[:user_id].present? # if request came from profile page
          flash.now[:error_user_post] = "error" # needed to determine which tab to open
          @posts = @user.posts.latest.page(params[:page]) # needed because we're rendering
          render "users/show"
        else
          render :index
        end
      end
    else
      flash.now[:error] = "Error posting content."
      render :index
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    if @post.attachments.present?
      @attachments = @post.attachments
    end
  end

  def update
    @post = Post.find_by(id: params[:id])
    if @post.attachments.present?
      @attachments = @post.attachments
    end

    if @post.valid?
      if @post.update_attributes(posts_params)
        flash[:success] = "Successfully updated the post!"
        redirect_to action: 'show'
      else
        flash.now[:error] = "Error updating the post."
        render :edit
      end
    else
      flash.now[:error] = "Error updating the post."
      render :edit
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:success] = "Successfully deleted the post!"
    redirect_to action: :index
  end

  def delete_image_attachment
    image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    flash[:success] = "Removed a photo from the post."
    redirect_back(fallback_location: posts_path)
  end

  private

  def posts_params
    params.require(:post).permit(:title, :body, attachments: [])
  end

  def get_posts
    @posts = Post.latest.page(params[:page])
  end

  def confirm_post_ownership
    post = Post.find_by(id: params[:id])
    unless post.user_id.to_i === session[:user_id].to_i
      flash[:error] = "Invalid action."
      redirect_to post_path(params[:id])
    end
  end
end