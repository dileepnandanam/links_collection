$(document).on('turbolinks:load', function() {
	$('.start').on('click', function() {
		$('.screen').children('span, img, video').css('display', 'none')
		elems = $('.screen').find('span, video, img')
		show(0, elems)
	})

	show = function(i, elems) {
		wait_time = 200
		if (i < elems.length) {
			if ($(elems[i]).text() == 'clrscr')
				$('.screen').find('span, img, video').css('display', 'none')
			else if ($(elems[i]).text() == 'bg')
				$('.screen').css('background-image', 'url(' + $(elems[i]).data('src') + ')')
			else if ($(elems[i]).text() == 'wait')
				wait_time = parseInt($(elems[i]).data('wait'))
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
