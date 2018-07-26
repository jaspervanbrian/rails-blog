class ConversationsController < ApplicationController
  before_action :confirm_authenticated

  def index
    @conversations = fetch_last_active_conversations
    if params[:to_id].present?
      @user = User.find_by(id: params[:to_id])
      unless @user.nil?
        @conversation = helpers.self_send?(@user) ? get_or_new_self_conversation
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
      initizalize_conversation
      ConversationsUser.create(conversation: @conversation, user: helpers.current_user)
      @conversation.users << @user if @conversation.type === "SingleConversation"
      @message = Message.new(message_params)
      @message.conversation = @conversation
      @message.user = helpers.current_user
      @message.save
      respond_to do |format|
        format.html { redirect_to conversation_path(@conversation) }
        format.js { render js: "window.location = '#{conversation_path(@conversation)}'"}
      end
    else
    end
  end

  def show
    @conversation = Conversation.find_by(id: params[:id])
    session[:temp_user_id] = nil
    if @conversation.nil? || !@conversation.users.include?(helpers.current_user)
      flash[:error] = "Conversation does not exist."
      redirect_to conversations_path
    else
      @conversations = fetch_last_active_conversations
      @message = Message.new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def get_or_new_single_conversation
    # repositories/conversations_users_repositories
    ConversationsUsersRepository.new.get_or_new_single_conversation(@user, session[:user_id])
  end

  def get_or_new_self_conversation
    ConversationsUsersRepository.new.get_or_new_self_conversation(session[:user_id])
  end

  def fetch_last_active_conversations
    helpers.current_user.conversations.includes(:messages).sort_by do |conversation|
      conversation.messages.max_by do |message|
        message.updated_at
      end
    end.reverse!
  end

  def message_params
    params.require(:message).permit(:body, attachments: [])
  end

  def conversation_persisted
    @conversation.persisted?
  end

  def initizalize_conversation
    @conversation = Conversation.new
    if helpers.self_send?(@user)
      @conversation.type = "SelfConversation"
    else
      @conversation.type = "SingleConversation"
    end
    @conversation.save
  end
end
