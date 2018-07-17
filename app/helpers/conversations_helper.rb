module ConversationsHelper
  def self_send?(user)
    user.id === session[:user_id]
  end
end
