class ConversationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    conversation = Conversation.find_by(id: params['conversation_id'])
    user = User.find_by(id: params['user_id'])
    if conversation.present? && user.present? && conversation.is_participant?(user)
      stream_from "conversation_#{params['conversation_id']}_channel"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
