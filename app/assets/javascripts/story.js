$(document).on('turbolinks:load', function() {
	var i = parseInt($('.current-elem').text())

	var periods = {
		faster: 100,
		fast: 200,
		slow: 500,
		veryslow: 1000
	}
	
	var period = periods['veryslow']
	$('.mvbar').addClass('soft stop')
	var stop = false

	move = function() {
		if (!stop) {
			if($('.mvbar').hasClass('stop'))
				$('.mvbar').removeClass('stop', parseInt(period / 2))
			else
				$('.mvbar').addClass('stop', parseInt(period / 2))
		}
		setTimeout(move, period / 2)
	}

	hideInst = function() {
		$('.inst').hide('fade')
	}

	show = function(elems) {
		var wait_time = 200
		var type = $(elems[i]).text()
		if (i < elems.length) {
			if (type == 'clrscr')
				$('.screen').find('span, img, video').css('display', 'none')
			else if (type == 'bg')
				$('.screen-cont').css('background-image', 'url(' + $(elems[i]).data('src') + ')')
			else if (type == 'wait')
				wait_time = parseInt($(elems[i]).data('wait'))
			else if (type == 'mode') { 
				mode = $(elems[i]).data('mode')
				if(mode == 'fast' || mode == 'faster' || mode == 'slow' || mode == 'veryslow') {
					stop = false
					period = periods[mode]
				}
				else if(mode == 'hard' || mode == 'medium' || mode == 'soft') {
					stop = false
					$('.mvbar').removeClass('soft')
					$('.mvbar').removeClass('medium')
					$('.mvbar').removeClass('hard')
					$('.mvbar').addClass(mode, 300)
				}
				else
					stop = true
			}
			else if (type == 'inst') {
				$('.inst .content').html($(elems[i]).data('inst'))
				$('.inst').show('fade')
				setTimeout(hideInst, 2500)
			}
			else if ($(elems[i]).data('type') == 'br')
				$(elems[i]).show()
			else
			{
				$(elems[i]).show('fade')
				var current_i = i
				$(elems[i]).on('click', function() {
					$('.current').val(current_i)
					$('form').submit()
				})
				if($(elems[i]).is('video'))
					elems[i].play()
			}
			$('.screen').scrollTop($('.screen').prop('scrollHeight'))
			setTimeout(function() { show(elems)}, wait_time)
		}
		i += 1
	}

	$('.back').on('click', function() {
		$(elems[i]).hide()
		i -= 1
	})

	$('.screen').children('span, img, video').css('display', 'none')
	elems = $('.screen').find('span, video, img')
	show(elems)
	move()
})
