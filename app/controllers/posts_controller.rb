class PostsController < ApplicationController
  def index
    @posts = Post.latest
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    post = Post.new(posts_params)
    user = User.find_by_email("jaspervanbrianmartin@gmail.com")
    unless user.nil?
      user.posts << post
    end
    redirect_to :action => 'index'
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end

  private

  def posts_params
    params.permit(:title, :body)
  end

end
