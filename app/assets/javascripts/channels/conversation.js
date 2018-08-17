$(document).on("turbolinks:load", function() {
  var conversation = $("#conversation");
  var conversation_box;
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
          var message = null;
        	conversation_box = $(conversation.children('.card-body').children('.col-12')[0]);
          var previous_message = conversation_box.children('.row').last();
          if(data['from'] == conversation.data("me")) {
            message = $(data['messages'][0]);
          	$("input#message_attachments").val(null);
            $("label.custom-file-label").text("No attachment selected.");
          	$("textarea").val("");
          } else {
            message = $(data['messages'][1]);
          }
          insertMessage(conversation_box, message, previous_message);
        }
        conversation_box = conversation.children('.card-body');
        conversation_box.scrollTop(conversation_box[0].scrollHeight);
      },
    });
  }
});

function insertMessage(conversation_box, message, previous_message) {
  var previous_message_timestamp = moment(previous_message.find('[data-timestamp]').data("timestamp"), "YYYY-MM-DD HH:mm:ss");
  var message_timestamp = moment(message.find('[data-timestamp]').data("timestamp"), "YYYY-MM-DD HH:mm:ss");
  var previous_sender = previous_message.children('span').first().data('sender');
  console.log(previous_message_timestamp)
  console.log(message_timestamp)
  console.log((message_timestamp.diff(previous_message_timestamp, 'hours')));
  if((message_timestamp.diff(previous_message_timestamp, 'hours')) >= 2) {
    conversation_box.append(`
      <div class="row">
        <div class="col-12 text-center">
          <small class="text-muted">
            ${message_timestamp.format("MMMM DD, YYYY | h:mm A (dddd)")}
          </small>
        </div>
      </div>
    `);
    conversation_box.append(message.closest('.new'));
    message.closest('.new').find('[data-toggle="tooltip"]').tooltip();
    message.closest('.old').remove();
  } else {
    if(message.find('span').first().data('sender') == previous_sender){
      conversation_box.append(message.closest('.old'));
      message.closest('.old').find('[data-toggle="tooltip"]').tooltip();
      message.closest('.new').remove();
    } else {
      conversation_box.append(message.closest('.new'));
      message.closest('.new').find('[data-toggle="tooltip"]').tooltip();
      message.closest('.old').remove();
    }
  }
}
