class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    user = User.first
    if Comment.create(body: params[:body], user: user, post: post).valid?
      flash[:success] = "Successfully comented on the post!"
    else
      flash[:error] = "Error commenting."
    end
    redirect_to post_path(post)
  end

  def destroy
  end

end
