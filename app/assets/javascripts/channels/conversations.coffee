$(document).on "turbolinks:load", ->
  conversations = $("#conversations")
  App.conversations = App.cable.subscriptions.create {
      channel: "ConversationsChannel",
      user_id: conversations.data("user-id")
    },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      if(data['conversation'])
        conversation = $(data['conversation'])
        actual_timestamp = $(conversation.find('.timestamp').first())
        last_message_date = moment(actual_timestamp.data('timestamp'), "YYYY-MM-DD HH:mm:ss")

        update_actual_timestamp(actual_timestamp, last_message_date)
        setInterval(->
          update_actual_timestamp(actual_timestamp, last_message_date)
        , 60000)
        if(conversations.children("a#" + conversation.attr("id")).length)
          conversations.children("a#" + conversation.attr("id")).remove()
        else if(conversations.children(".alert.alert-info").length)
          conversations.children(".alert.alert-info").remove()
        conversations.prepend(conversation)

	update_actual_timestamp = (actual_timestamp, last_message_date) ->
    if(moment().isBefore(last_message_date, 'year'))
      actual_timestamp.text(last_message_date.month() + "/" + last_message_date.date() + "/" + last_message_date.year())
    else
   		actual_timestamp.text(last_message_date.fromNow())
