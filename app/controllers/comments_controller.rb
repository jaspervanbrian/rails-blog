class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    user = User.first
    Comment.create(body: params[:body], user: user, post: post)
    redirect_to post_path(post)
  end

  def destroy
  end

end
