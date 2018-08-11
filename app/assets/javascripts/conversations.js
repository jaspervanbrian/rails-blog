$(document).on("turbolinks:load", function() {
	if($("#conversation").data("conversation-id")) {
		var chatbox = $("#conversation").children(".card-body");
		chatbox.scrollTop(chatbox[0].scrollHeight);
	}
	var conversations = $("#conversations");
	if(conversations.find(".timestamp").length) {
		var timestamps = conversations.find(".timestamp");
		for(var i = 0; i < timestamps.length; i++) {
			actual_timestamp = $(timestamps[i]);
			last_message_date = moment(actual_timestamp.data('timestamp'), "YYYY-MM-DD HH:mm:ss");

	    set_actual_timestamp(actual_timestamp, last_message_date);
			(function(actual_timestamp, last_message_date) {
		    setInterval(function() {
	      	set_actual_timestamp(actual_timestamp, last_message_date);
				}, 60000);
			})(actual_timestamp, last_message_date);
		}
	}
});

function set_actual_timestamp(actual_timestamp, last_message_date) {
  if(moment().isBefore(last_message_date, 'year'))
    actual_timestamp.text(last_message_date.month() + "/" + last_message_date.date() + "/" + last_message_date.year())
  else
 		actual_timestamp.text(last_message_date.fromNow())
}
