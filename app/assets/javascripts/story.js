$(document).on('turbolinks:load', function() {
	$('.start').on('click', function() {
		$('.screen').html('')
		elems = $('.script').find('span, iframe, img')
		show(0, elems)
	})

	show = function(i, elems) {
		if (i < elems.length) {
			if ($(elems[i]).text == 'clrscr')
				$('.screen').html('')
			else
			{
				$('.screen').append(elems[i].outerHTML)
				$('.screen').find(':last-child').show('fade')
				if($(elems[i]).is('iframe'))
					$('.screen').find(':last-child').attr('src', $('.screen').find(':last-child').attr('src') + "&autoplay=1")
			}
			setTimeout(function() { show(i + 1, elems)}, 100)
		}
	}
})
