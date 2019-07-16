$(document).on('turbolinks:load', function() {
	$('.start').on('click', function() {
		$('.screen').children('span, img, video').css('display', 'none')
		elems = $('.screen').find('span, video, img')
		show(0, elems)
		move()
	})

	var periods = {
		faster: 100,
		fast: 200,
		slow: 500,
		veryslow: 1000
	}
	
	var period = periods['veryslow']
	$('.mvbar').addClass('soft')
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
		$('.inst').hide('slow')
	}

	show = function(i, elems) {
		var wait_time = 200
		var type = $(elems[i]).text()
		if (i < elems.length) {
			if (type == 'clrscr')
				$('.screen').find('span, img, video').css('display', 'none')
			else if (type == 'bg')
				$('.screen').css('background-image', 'url(' + $(elems[i]).data('src') + ')')
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
				$('.inst').html($(elems[i]).data('inst'))
				$('.inst').show('fast')
				setTimeout(hideInst, 2500)
			}
			else if ($(elems[i]).data('type') == 'br')
				$(elems[i]).hide()
			else
			{
				$(elems[i]).show('fade')
				if($(elems[i]).is('video'))
					elems[i].play()
			}
			$('.screen').scrollTop($('.screen').prop('scrollHeight'))
			setTimeout(function() { show(i + 1, elems)}, wait_time)
		}
	}


})
