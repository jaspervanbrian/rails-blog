$(document).on("turbolinks:load", function() {
  var conversation = $("#conversation");
  var conversation_box;
  console.log(typeof conversation.data("conversation-id"))
  if(typeof conversation.data("conversation-id") !== "undefined") {
    App.conversation = App.cable.subscriptions.create({
      channel: "ConversationChannel",
      conversation_id: conversation.data("conversation-id"),
      user_id: conversation.data("me")
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
        	conversation_box = $(conversation.children('.card-body').children('.col-12')[0]);
          var previous_message = conversation_box.children('.row').last();
          var previous_sender = previous_message.children('span').first().data('sender');
          if(data['from'] == conversation.data("me")) {
            var message = $(data['messages'][0]);
            if(message.find('span').first().data('sender') == previous_sender){
              conversation_box.append(message.closest('.old'));
            } else {
              conversation_box.append(message.closest('.new'));
            }
          	$("input#message_attachments").val(null);
            $("label.custom-file-label").text("No attachment selected.");
          	$("textarea").val("");
          } else {
            var message = $(data['messages'][1]);
            if(message.find('span').first().data('sender') == previous_sender){
              conversation_box.append(message.closest('.old'));
            } else {
              conversation_box.append(message.closest('.new'));
            }
          }
        }
        conversation_box = conversation.children('.card-body');
        conversation_box.scrollTop(conversation_box[0].scrollHeight);
      },
    });
  } else {
    
  }
});
