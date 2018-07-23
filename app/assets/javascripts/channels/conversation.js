$(document).on("turbolinks:load", function() {
  var conversation = $("#conversation");
  App.conversation = App.cable.subscriptions.create({
    channel: "ConversationChannel",
    conversation_id: conversation.data("conversation-id")
  }, {
    connected: function() {
      // Called when the subscription is ready for use on the server
    },

    disconnected: function() {
      // Called when the subscription has been terminated by the server

    },

    received: function(data) {
      if(data['messages'].length !== 0) {
        // Called when there's incoming data on the websocket for this channel
        console.log(data['from'], conversation.data("me"))
      	var conversation_box = conversation.find('.card-body').find('.col-12').first();
        if(data['from'] == conversation.data("me")) {
        	conversation_box.append(data['messages'][0]);
        } else {
        	conversation_box.append(data['messages'][1]);
        }
        conversation_box = conversation.find('.card-body');
        conversation_box.scrollTop(conversation_box[0].scrollHeight);
      }
    },
  });
});
