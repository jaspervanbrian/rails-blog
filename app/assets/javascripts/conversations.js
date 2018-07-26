$(document).on("turbolinks:load", function() {
	var chatbox = $("#conversation").children(".card-body");
	chatbox.scrollTop(chatbox[0].scrollHeight);
});
