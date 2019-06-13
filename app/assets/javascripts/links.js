$(document).on('turbolinks:load', function() {
	initMasonry = function() {
		$('.links').masonry({
			itemSelector: '.link, .load-random'
		})
	}
	reinitMasonry = function() {
		$('.links').masonry('destroy')
		initMasonry()
	}
	reloadMasonry = function() {
		$('.links').masonry('reloadItems')
		initMasonry()
	}
	initMasonry()

	search = function() {
		query = $('.search input').val()
		$.ajax({
			url: $(this).data('url'),
			data: {
				q: query
			},
			success: function(data) {
				$('.links').html(data)
				reinitMasonry()
				host = document.location.host
				window.history.pushState(null, 'search for: ' + query, '?q=' + query)
			}
		})
	}

	$(document).on('ajax:success', '.tag', function(e) {
		$('.links').html(e.detail[2].responseText)
		reinitMasonry()
	})

	$('.search input').keyup($.debounce(250, search))

	$('.links').on('ajax:success', '.view-more', function(e) {
		$(this).closest('.more-links').replaceWith(e.detail[2].responseText)
		reloadMasonry()
	})

	$(document).on('ajax:success', '.form', function(e) {
		$('#link_name').val('')
		$('#link_url').val('')
		$('#link_tags').val('')
		$(this).closest('.form-container').addClass('d-none')
	}).on('ajax:error', '.form', function(e) {
		$(this).closest('.form-container').html(e.detail[2].responseText)
	})

	$('.new-link').on('click', function() {
		$('.form-container').removeClass('d-none')
	})

	window.onscroll = function() {
		if($(window).height() + 600 + document.documentElement.scrollTop > $('body').height()) {
			animate_loader($('.loader'))
			Rails.fire($('.view-more')[0], 'click')
		}
	}
	$(document).on('keypress', 'input.tag', function(e){
		if(e.which == 13) {
			$.ajax({
				url: $(this).data('url'),
				method: 'PUT',
				data: {value: $(this).val()},
				beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
				success: function(e) {
					$('input').val('')
				}
			})
		}
	})

	$(document).on('click', '.watch-now', function() {
		$(this).siblings('.preview').removeClass('d-none')
	})

	$(document).on('ajax:success', '.retry', function(e) {
		$(this).siblings('.preview').find('video').prop('src', e.detail[2].responseText)
	})

	$(document).on('ajax:success', '.load-random', function(e) {
		$(this).replaceWith(e.detail[2].responseText)
		reloadMasonry()
	})

	animate_loader = function(e) {
		e.html(e.html() + '.')
		setTimeout(function(){animate_loader(e)}, 1000)
	}

	$('.links').scrollTop(0)


})