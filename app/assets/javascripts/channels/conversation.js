App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  	
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
  	var conversation = $("#conversation").find('.card-body')
  	conversation.append(data['message']);
  	conversation.scrollTop(messages[0].scrollHeight);
  },
});
