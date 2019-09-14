$(document).on('turbolinks:load', function() {
	$('.create-affiliation-form').on('ajax:success', function(e) {
		$('.affiliations').append(e.detail[2].responseText)
		$(this).closest('.new-affiliation-form').addClass('d-none')
	})

	$(document).on('ajax:success', '.update-affiliation-form', function(e) {
		$(this).closest('.affiliation').html(e.detail[2].responseText)
		$(this).addClass('d-none')
	})
})