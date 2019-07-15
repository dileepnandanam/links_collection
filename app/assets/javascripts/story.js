$(document).on('turbolinks:load', function() {
	$('.start').on('click', function() {
		$('.screen').children('span, img, video').css('display', 'none')
		elems = $('.screen').find('span, video, img')
		show(0, elems)
		move()
	})

	var speeds = {
		faster: 4,
		fast: 10,
		slow: 25,
		veryslow: 35
	}
	var strengths = {
		soft: 400,
		medium: 200,
		hard: 0
	}
	var direction = 1
	var period = speeds['veryslow']
	var disp = 30
	var height = strengths['soft']
	var max = 0
	var min = 600
	var stop = false

	move = function() {
		if (!stop) {
			if (height < max)
				direction = 1
			else if (height > min)
				direction = -1
			height += direction * disp
			$('.mvbar').css('height', height, 'fast')
		}
		setTimeout(move, period)
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
					period = speeds[mode]
				}
				else if(mode == 'hard' || mode == 'medium' || mode == 'soft') {
					stop = false
					max = strengths[mode]
				}
				else
					stop = true
			}
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
