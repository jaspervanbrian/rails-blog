class CommentsController < ApplicationController
  before_action :confirm_authenticated
  before_action :confirm_comment_ownership, only: [:destroy]

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

  private

  def confirm_comment_ownership
    comment = Comment.find_by(id: params[:id])
    unless comment.user_id.to_i === session[:user_id].to_i
      flash[:error] = "Invalid action."
      redirect_to post_path(params[:post_id])
    end
  end
end
