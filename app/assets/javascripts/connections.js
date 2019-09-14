$(document).on('turbolinks:load', function() {
	scroll_to_bottom = function() {
		$('.chat-thread').scrollTop($('.chat-thread').prop('scrollHeight'))
	}

	$('.chat-thread').scrollTop($('.chat-thread').prop('scrollHeight'))

	$('.select-connection').on('ajax:success', function(e) {
		$('.chats').html(e.detail[2].responseText)
		scroll_to_bottom()
		$(this).find('.question').removeClass('have-new-chat')
		$(this).find('.unseen-count').addClass('d-none')
		$(this).find('.unseen-count').html('0')
	})

	$('.chats').on('ajax:success', 'form', function(e) {
		$('.chat-thread').append(e.detail[2].responseText)
		$(this).find('textarea').val('')
		scroll_to_bottom()
	})

	$('.chats').on('keypress', 'textarea', function(e) {
		if(e.which == 13)
			Rails.fire($(this).closest('form')[0], 'submit')
	})

	$(document).on('click', '.imogee', function() {
		textarea = $(this).closest('.imogee-list').siblings('.form-group').find('textarea')
		$(textarea).val($(textarea).val() + $(this).data('imogee').trim())
	})
})