$('body').prepend('<div class="add-link" onClick="send()" style="width: 100%; height: 50px; color: green;"/>')
var send = function() {
	$.ajax({
		url: 'localhost:3000/links',
		data: {link: {url: window.location.href}},
		method: 'POST'
	})
}