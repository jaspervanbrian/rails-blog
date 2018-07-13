class ConversationsUsersRepository
  def get_user_conversation(user, my_id)
    conversation = Conversation.new(name: user.full_name)
    conversationsUsers = ConversationsUser.where(user_id: [user.id, my_id])
    if conversationsUsers.present?
      conversationsUsers.each do |conversationUser|
        temp_conversation = conversationUser.conversation # conversation between me and the user clicked
        users = temp_conversation.users # users of this conversation
        if temp_conversation.name.nil? && (users.length === 2) && ((users.include?(@user.id) && users.include?(session[:user_id]))) # Checks if the conversation has only 2 users (You and your friend) and the default is no conversation name because it uses your friends name as convo name
          conversation = temp_conversation
          break
        end
      end
    end
    conversation
  end
end