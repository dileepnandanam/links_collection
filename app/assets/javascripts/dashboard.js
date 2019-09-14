$(document).on('turbolinks:load', function() {
	$('.add-question').on('ajax:success', function(e){
		$('.new-question').html(e.detail[2].responseText)
	})
	$('.new-question').on('click', '.cancel-form', function() {
		$(this).closest('form').remove()
	})

	$('.new-question').on('ajax:success', 'form', function(e) {
		$('.questions-container').append(e.detail[2].responseText)
		$(this).remove()
		$('.question.help-text').remove()
	}).on('ajax:error', function(e) {
		$('.new-question').html(e.detail[2].responseText)
	})

	$('.questions-container').on('ajax:success', '.edit-question', function(e) {
		$(this).closest('.question').find('.question-edit-form-container').html(e.detail[2].responseText)
	})

	$('.questions-container').on('click', '.cancel-form', function() {
		$(this).closest('form').remove()
	})

	$('.questions-container').on('ajax:success', 'form', function(e) {
		$(this).closest('.question').replaceWith(e.detail[2].responseText)
	}).on('ajax:error', 'form', function(e) {
		$(this).closest('.question-edit-form-container').html(e.detail[2].responseText)
	})

	$('.questions-container').on('ajax:success', '.delete-question', function() {
		$(this).closest('.question').remove()
	})

	$('.questions-container.reorderable').sortable({
		stop: function() {
			$.ajax({
				data: $('.questions-container').sortable('serialize'),
				url: '/questions/reorder',
				method: 'PUT'
			})
		}
	})

	$('.responses-container').on('ajax:success', '.accept-response', function(e) {
		$(this).closest('.answer-action').html(e.detail[2].responseText)
	})

	$('.accepted_responses, .responses-container, .questions, .questions-container').on('ajax:success', '.view-more', function(e) {
		$(this).closest('.more-responses').replaceWith(e.detail[2].responseText)
	})

	$('.filter-response-link').on('ajax:success', function(e) {
		$('.responses-container').html(e.detail[2].responseText)
	})
})