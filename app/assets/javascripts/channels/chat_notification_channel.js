$(document).on('turbolinks:load', function() {
	App.cable.subscriptions.create("ApplicationCable::ChatNotificationsChannel", {
		received(data) {
			$('.my-connections').addClass('has-new-chats')
			chat_thread = $('#' + data['sender_id'] + '.chat-thread')
			if(chat_thread.length == 0) {
				chat_ico = $('#' + data['sender_id'] + '.question')
				if(chat_ico.length == 0) {
					$('.unseen-mark').removeClass('d-none')
				} else {
					chat_ico.addClass('have-new-chat')
					unseen_chat_count = chat_ico.find('.unseen-count')
					unseen_chat_count.html(parseInt(unseen_chat_count.html())+1)
					unseen_chat_count.removeClass('d-none')
				}
			} else {
				chat_thread.append(data['chat'])
				$('.chat-thread').scrollTop($('.chat-thread').prop('scrollHeight'))
				$.ajax({
					url: data['ack_url'],
					method: 'PUT'
				})
			}
		}
	})
})