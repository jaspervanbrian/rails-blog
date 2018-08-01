class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    conversation = Conversation.find_by(id: params[:conversation_id])
    @message.conversation = conversation
    @message.user = helpers.current_user
    if @message.valid?
      @message.save

      ActionCable.server.broadcast("conversation_#{conversation.id}_channel",
        messages: [render_my_message, render_message],
        from: @message.user.id
      )

      conversation.user_ids.each do |user_id|
        ActionCable.server.broadcast("conversations_#{user_id}",
          messages: [render_my_message, render_message],
          from: @message.user.id
        )
      end

      head :ok
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, attachments: [])
  end

  def render_conversation_partial(conversation)
    render_to_string(
      partial: "partials/conversation",
      locals: {
        conversation: conversation
      }
    )
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
