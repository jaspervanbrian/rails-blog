class MessagesController < ApplicationController
  def create
    message = Message.new(message_params)
    conversation = Conversation.find_by(id: params[:conversation_id])
    message.conversation = conversation
    message.user = helpers.current_user
    message.save

    respond_to do |format|
      format.html { redirect_to conversation_path(conversation) }
      format.js
    end
  end

  private
  
  def message_params
    params.require(:message).permit(:body, attachments: [])
  end
end
