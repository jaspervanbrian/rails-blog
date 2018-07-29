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
