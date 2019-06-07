$(document).on('turbolinks:load', function() {
	search = function() {
		query = $('.search input').val()
		$.ajax({
			url: $(this).data('url'),
			data: {
				q: query
			},
			success: function(data) {
				$('.links').html(data)
			}
		})
	}

	$(document).on('ajax:success', '.tag', function(e) {
		$('.links').html(e.detail[2].responseText)
	})

	$('.search input').keyup($.debounce(250, search))

	$('.links').on('ajax:success', '.view-more', function(e) {
		$(this).closest('.more-links').replaceWith(e.detail[2].responseText)
	})

	$(document).on('ajax:success', '.form', function(e) {
		$(this).find('input').val('')
		$(this).closest('.form-container').addClass('d-none')
	}).on('ajax:error', '.form', function(e) {
		$(this).closest('.form-container').html(e.detail[2].responseText)
	})

	$('.new-link').on('click', function() {
		$('.form-container').removeClass('d-none')
	})
})