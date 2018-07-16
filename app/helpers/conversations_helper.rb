module ConversationsHelper
  def self_send?
    @user.id === session[:user_id]
  end
end
