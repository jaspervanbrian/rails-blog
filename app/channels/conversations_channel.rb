class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "conversatons_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
