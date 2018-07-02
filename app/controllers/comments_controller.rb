class CommentsController < ApplicationController
  before_action :confirm_authenticated
  before_action :confirm_comment_ownership, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    if @post.images.present?
      @images = @post.images
    end
    user = User.find_by(id: session[:user_id])

    @comment = Comment.new(comments_params)
    @comment.user = user
    @comment.post = @post

    if @comment.valid?
      if @comment.save
        flash[:success] = "Successfully comented on the post!"
        redirect_to post_path(@post)
      else
        flash.now[:error] = "Error commenting."
        render "posts/show"
      end
    else
      flash.now[:error] = "Error commenting."
      render "posts/show"
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    comment = Comment.find_by(id: params[:id])

    if comment.destroy
      flash[:success] = "Comment deleted successfully!"
    else
      flash[:error] = "Error deleting comment."
    end
    redirect_to post_path(post)
  end

  private

  def comments_params
    params.require(:comment).permit(:body, images: [])
  end

  def confirm_comment_ownership
    comment = Comment.find_by(id: params[:id])
    unless comment.user_id.to_i === session[:user_id].to_i
      flash[:error] = "Invalid action."
      redirect_to post_path(params[:post_id])
    end
  end
end
