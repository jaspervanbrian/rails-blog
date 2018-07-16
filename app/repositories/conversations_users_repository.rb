class ConversationsUsersRepository
  def get_single_conversation(user, my_id)
    conversation_id = ConversationsUser.where(user_id: [user.id, my_id])
                      .group("conversation_id")
                      .having("count(user_id) = 2")
                      .pluck("conversation_id")
                      .first
    Conversation.find_by(id: conversation_id) || Conversation.new
  end

  def get_self_conversation(my_id)
    conversation = Conversation.where(type: "SelfConversation")
                    .left_joins(:conversations_users)
                    .where("conversations_users.user_id  = ?", my_id)
                    .first
    conversation
  end
end