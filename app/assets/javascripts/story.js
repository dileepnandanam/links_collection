$(document).on('turbolinks:load', function() {
	$('.start').on('click', function() {
		$('.screen').children('span, img, iframe').css('display', 'none')
		elems = $('.screen').find('span, iframe, img')
		show(0, elems)
	})

	show = function(i, elems) {
		wait_time = 200
		if (i < elems.length) {
			if ($(elems[i]).text() == 'clrscr')
				$('.screen').find('span, img, iframe').css('display', 'none')
			else if ($(elems[i]).text() == 'wait')
				wait_time = parseInt($(elems[i]).data('wait'))
			else
			{
				$(elems[i]).show('fade')
				if($(elems[i]).is('iframe'))
					elems[i].src += "&autoplay=1"
			}
			$('.screen').scrollTop($('.screen').prop('scrollHeight'))
			setTimeout(function() { show(i + 1, elems)}, wait_time)
		}
	}
})
