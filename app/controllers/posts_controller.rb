class PostsController < ApplicationController
  before_action :get_posts, only: [:index, :create]
  before_action :confirm_authenticated, except: [:index, :show]
  before_action :confirm_post_ownership, only: [:edit, :update, :destroy]

  def index
    @post = Post.new
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def create
    @post = Post.new(posts_params)
    user = User.find_by(id: session[:user_id])
    unless user.nil?
      user.posts << @post
      if @post.valid?
        flash[:success] = "Successfully posted a content!"
        redirect_to :action => 'index'
      else
        flash.now[:error] = "Error posting content."
        render :index
      end
    else
      flash.now[:error] = "Error posting content."
      render :index
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(posts_params)
      flash[:success] = "Successfully updated the post!"
      redirect_to action: 'show'
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

  private

  def posts_params
    params.require(:post).permit(:title, :body)
  end

  def get_posts
    @posts = Post.latest.page(params[:page])
  end

  def confirm_authenticated
    unless session[:user_id]
      flash[:error] = "Please log in first."
      redirect_to login_path
    end
  end

  def confirm_post_ownership
    post = Post.find_by(id: params[:id])
    unless post.user_id.to_i === session[:user_id].to_i
      flash[:error] = "Invalid action."
      redirect_to post_path(params[:id])
    end
  end
end
