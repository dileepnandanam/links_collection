$(document).on('turbolinks:load', function() {
	speed = 0
	position = 0
	homes = $('.homes')
	background = $('.background')
	keydown = false

	var distance_yard_map = {}
	var yard_length = 400
	var popup_visible = false

	$('.view-neibhourhood').on('click', function(e) {
		e.preventDefault()
		$('.neibhourhood-container').removeClass('d-none')
		$(this).remove()
	})
	$.each($('.yard'), function(i, yard) {
		distance_yard_map[i] = yard
	})

	popup_for_yard = function() {
		yard_index = parseInt((parseInt(homes.css('left')) - parseInt($('.car').css('left'))) / yard_length)
		yard = distance_yard_map[-1 * yard_index]
		if(yard)
			yard.click()
	}

	repaint = function(position) {
		homes.css('left', parseInt(position * 0.5))
		background.css('left', parseInt(position * 0.1))
	}

	move = function() {
		$('.wall-expanded').addClass('d-none')
		if(speed == 0)
			return
		else {
			position = position - speed
			repaint(position)
			setTimeout(move, 10)
		}
	}

	move_right = function() {
		speed = 5
		move()
	}

	move_left = function() {
		speed = -5
		move()
	}

	stop = function() {
		speed = 0
		popup_for_yard()
	}

	$('.right').on('mousedown', function() {
		move_right()
	}).on('mouseup', function() {
		stop()
	})

	$('.right').on('touchstart', function(e) {
		e.preventDefault()
		move_right()
	}).on('touchend', function() {
		stop()
	})

	$('.left').on('mousedown', function() {
		move_left()
	}).on('mouseup', function() {
		stop()
	})

	$('.left').on('touchstart', function(e) {
		e.preventDefault()
		move_left()
	}).on('touchend', function() {
		stop()
	})

	$(document).on('keydown', function(e) {
		if(keydown == false) {
			keydown = true
			if(e.which == 37)
				move_left()
			else if(e.which == 39)
				move_right()
		}
	}).on('keyup', function(e) {
		if(e.which == 37 || e.which == 39) {
			keydown = false
			stop()
		}
		
	})


	$('.yard').on('click', function() {
		url = $(this).data('posts-url')
		$.ajax({
			url: url,
			method: 'GET',
			success: function(data) {
				$('.posts-container').html(data)
				$('.wall-expanded').removeClass('d-none')
				$('.posts').scrollTop($('.posts').prop('scrollHeight'))
			}
		})
		

	})





	$('.wall-expanded').on('ajax:success', 'form', function(e) {
		$('.posts').append(e.detail[2].responseText)
		$(this).find('textarea').val('')
		$('.posts').scrollTop($('.posts').prop('scrollHeight'))
	})
	$('.wall-close').on('click', function() {
		$('.wall-expanded').addClass('d-none')
	})
	$('.posts-container').on('ajax:success', '.delete-post', function() {
		$(this).closest('.post').remove()
	})
})