class ConversationsController < ApplicationController
  before_action :confirm_authenticated

  def index
    @conversations_with_users = ConversationsUser.where(user_id: session[:user_id]).latest
    if params[:to_id].present?
      @user = User.find_by(id: params[:to_id])
      unless @user.nil?
        @conversation = get_user_conversation
        unless @conversation.new_record?
          redirect_to conversation_path(@conversation)
        end
        @message = Message.new(conversation: @conversation, user: helpers.current_user)
      else
        flash[:error] = "User does not exist."
        redirect_to conversations_path
      end
    end
  end

  def create

  end

  def show
    @conversations_with_users = ConversationsUser.where(user_id: session[:user_id]).latest
    @conversation = Conversation.find_by(id: params[:id])
    if @conversation.nil?
      flash[:error] = "Conversation does not exist."
      redirect_to conversations_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def get_user_conversation
    ConversationsUsersRepository.new.get_user_conversation(@user, session[:user_id]) # repositories/conversations_users_repositories
  end
end