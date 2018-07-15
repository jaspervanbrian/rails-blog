class MessagesController < ApplicationController
  def create
    message = Message.new(message_params)
    conversation = Conversation.find_by(id: params[:conversation_id])
    message.conversation = conversation
    message.user = helpers.current_user
    message.save
    redirect_to conversation_path(conversation)
  end

  private
  
  def message_params
    params.require(:message).permit(:body, attachments: [])
  end
end
