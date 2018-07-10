class ConversationsController < ApplicationController
  def index
    @conversations_with_users = ConversationsUser.where(user_id: session[:user_id]).latest
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
