class ConversationsController < ApplicationController
  before_action :confirm_authenticated

  def index
    @conversations = helpers.current_user.conversations.latest
    if params[:to_id].present?
      @user = User.find_by(id: params[:to_id])
      unless @user.nil?
        @conversation = helpers.self_send? ? get_or_new_self_conversation
                                            : get_or_new_single_conversation
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
      if helpers.self_send?
        @conversation = get_or_new_self_conversation
        redirect_to conversation_path(@conversation) if @conversation.persisted?
        @conversation.type = "SelfConversation"
      else
        @conversation = get_or_new_single_conversation
        redirect_to conversation_path(@conversation) if @conversation.persisted?
        @conversation.type = "SingleConversation"
      end

      @conversation.save
      ConversationsUser.create(conversation: @conversation, user: helpers.current_user)
      @conversation.users << @user if @conversation.type === "SingleConversation"

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
    if !@conversation.users.include?(helpers.current_user) || @conversation.nil?
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

  def get_or_new_single_conversation
    ConversationsUsersRepository.new.get_or_new_single_conversation(@user, session[:user_id]) # repositories/conversations_users_repositories
  end

  def get_or_new_self_conversation
    ConversationsUsersRepository.new.get_or_new_self_conversation(session[:user_id])
  end

  def message_params
    params.require(:message).permit(:body, attachments: [])
  end
end