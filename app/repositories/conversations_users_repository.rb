class ConversationsUsersRepository
  def get_single_conversation(user, my_id)
    conversation = Conversation.new
    conversationsUsers = ConversationsUser.where(user_id: [user.id, my_id])
    if conversationsUsers.present?
      conversationsUsers.each do |conversationUser|
        temp_conversation = conversationUser.conversation # conversation between me and the user clicked
        if temp_conversation.type === "single"
          users = temp_conversation.users # users of this conversation
          if user.id == my_id && users.length == 1
            conversation = temp_conversation
            break
          elsif ((users.include?(@user.id) && users.include?(session[:user_id]))) # Checks if the conversation has only 2 users (You and your friend) and the default is no conversation name because it uses your friends name as convo name
            conversation = temp_conversation
            break
          end
        end
      end
    end
    conversation
  end
end