class ConversationsUsersRepository
  def get_single_conversation(user, my_id)
    conversation_id = ConversationsUser.where(user_id: [user.id, my_id])
                      .group("conversation_id")
                      .having("count(user_id) = 2")
                      .pluck("conversation_id")
                      .first
    Conversation.find_by(id: conversation_id) || Conversation.new
  end
end