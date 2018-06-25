class PostsController < ApplicationController
  before_action :get_posts, only: [:index, :create]

  def index
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(posts_params)
    user = User.first
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
    @post = Post.find(params[:id])
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
    @post = Post.find(params[:id])
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
end
