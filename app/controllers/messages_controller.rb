class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    conversation = Conversation.find_by(id: params[:conversation_id])
    @message.conversation = conversation
    @message.user = helpers.current_user
    @message.save

    ActionCable.server.broadcast("conversation_#{conversation.id}_channel",
      messages: [render_my_message, render_message],
      from: @message.user.id
    )

    head :ok
    # respond_to do |format|
    #   format.html { redirect_to conversation_path(conversation) }
    #   format.js
    # end
  end

  private

  def message_params
    params.require(:message).permit(:body, attachments: [])
  end

  def render_my_message
    render_to_string(
      partial: "partials/my-message",
      locals: {
        message: @message,
        temp_user: true
      }
    )
  end

  def render_message
    render_to_string(
      partial: "partials/message",
      locals: {
        message: @message,
        temp_user: true
      }
    )
  end
end
