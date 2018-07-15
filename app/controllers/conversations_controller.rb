class ConversationsController < ApplicationController
  before_action :confirm_authenticated

  def index
    @conversations = helpers.current_user.conversations.latest
    if params[:to_id].present?
      @user = User.find_by(id: params[:to_id])
      unless @user.nil?
        @conversation = get_single_conversation
        unless @conversation.new_record?
          redirect_to conversation_path(@conversation)
        end
      else
        flash[:error] = "User does not exist."
        redirect_to conversations_path
      end
    end
  end

  def create
    if params[:to_id].present? && message_params.present?
      @user = User.find_by(id: params[:to_id])
      @conversation = get_single_conversation
      @conversation.type = "SingleConversation"
      @conversation.save
      ConversationsUser.create(conversation: @conversation, user: helpers.current_user)
      @conversation.users << @user

      @message = Message.new(message_params)
      @message.conversation = @conversation
      @message.user = helpers.current_user
      @message.save

      redirect_to conversation_path(@conversation)
    else
    end
  end

  def show
    @conversations = helpers.current_user.conversations.latest
    @conversation = Conversation.find_by(id: params[:id])
    if @conversation.nil?
      flash[:error] = "Conversation does not exist."
      redirect_to conversations_path
    end
    @message = Message.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def get_single_conversation
    ConversationsUsersRepository.new.get_single_conversation(@user, session[:user_id]) # repositories/conversations_users_repositories
  end

  def message_params
    params.require(:message).permit(:body, attachments: [])
  end
end