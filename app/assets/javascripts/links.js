$(document).on('turbolinks:load', function() {
	initMasonry = function() {
		$('.links').masonry({
			itemSelector: '.link, .load-random',
			gutter: 100
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
	//initMasonry()

	search = function() {
		query = $('.search input').val()
		$.ajax({
			url: $(this).data('url'),
			data: {
				q: query
			},
			success: function(data) {
				$('.links').html(data)
				//reinitMasonry()
				reloadVideo()
				window.history.pushState(null, 'search for: ' + query, '?q=' + query)
			}
		})
	}

	$('.links').scrollTop(0)

	$(document).on('ajax:success', '.tag', function(e) {
		$('.links').html(e.detail[2].responseText)
		window.history.pushState(null, 'search for: ' + $(this).html(), '?q=' + $(this).html())
		//reinitMasonry()
		reloadVideo()
	})

	$('.search input').keyup($.debounce(1000, search))

	$('.links').on('ajax:success', '.view-more', function(e) {
		$(this).closest('.more-links').replaceWith(e.detail[2].responseText)
		//reloadMasonry()
		reloadVideo()
	})

	$(document).on('ajax:success', '.form', function(e) {
		$('#link_name').val('')
		$('#link_url').val('')
		$('#link_tags').val('')
		$(this).closest('.form-container').hide()
	}).on('ajax:error', '.form', function(e) {
		$(this).closest('.form-container').html(e.detail[2].responseText)
	})

	$('.new-link').on('click', function() {
		$('.form-container').show('fast')
	})

	click_more_link = function() {
		Rails.fire($('.view-more')[0], 'click')
	}
	sent = {}
	window.onscroll = function() {
		if($(window).height() + 600 + document.documentElement.scrollTop > $('body').height()) {
			height = $('body').height().toString()
			if(!sent[height]) {
				sent[height] = true
				click_more_link()
			}
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

	$(document).on('ajax:success', '.retry', function(e) {
		$(this).siblings('.preview').find('video').prop('src', e.detail[2].responseText)
	})

	$(document).on('ajax:success', '.load-random', function(e) {
		$(this).replaceWith(e.detail[2].responseText)
		//reloadMasonry()
		reloadVideo()
	})

	animate_loader = function(e) {
		e.html(e.html() + '.')
		setTimeout(function(){animate_loader(e)}, 500)
	}

	reloadVideo = function() {
		for(i = 0; i < $('video').length; i++) {
			if($('video')[i].networkState == 3)
				Rails.fire($($('video')[i]).closest('.link').find('.retry')[0], 'click')
		}
	}
	setTimeout(reloadVideo, 1000)
})