$(document).on("turbolinks:load", function() {
	if($("#conversation").data("conversation-id")) {
		var chatbox = $("#conversation").children(".card-body");
		chatbox.scrollTop(chatbox[0].scrollHeight);
	}
});
