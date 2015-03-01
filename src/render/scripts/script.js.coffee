$ ->
	# change html tag type
	$.fn.changeElementType = (newType) ->
		attrs = {}
		$.each @[0].attributes, (idx, attr) ->
			attrs[attr.nodeName] = attr.value
			return
		@replaceWith ->
			$('<' + newType + '/>', attrs).append $(this).contents()
		return @

	# smooth scroll
	menuHeight = 60
	$('a[href*=#]:not([href=#])').click ->
		if location.pathname.replace(/^\//, '') == @pathname.replace(/^\//, '') and location.hostname == @hostname
			target = $(@hash)
			target = if target.length then target else $('[name=' + @hash.slice(1) + ']')
			if target.length
				$('html,body').animate { scrollTop: target.offset().top - menuHeight}, 1000
				return false
		return


	# parameter should be the serializeArray()'s result on the form
	formatFormInput = (serializedArray)->
		orig = serializedArray
		data = {}
		for dat in orig
			multivalue = 0
			multivalue++ for actual in orig when dat.name is actual.name
			if multivalue is 1 or !data[dat.name]?
				data[dat.name] = dat.value
			else
				data[dat.name] += ', ' + dat.value
		data


	$('form').submit (e)->
		self = $ this
		unless self.data('sent')?
			data = formatFormInput(self.serializeArray())

			createHtml = (data)->
				s = '<h2>Új ajánlatkérés érkezett:</h2>'
				s += "<p><b>Feladó</b>: #{data['name']}</p>"
				s += "<p><b>E-mail</b>: #{data['email']}</p>"
				s += "<p><b>Leírás</b>:</p><p>#{data['comment']}</p>"

				s + '<br />'

			subject = '[Brainr] Árajánlat kérés - ' + data['name']
			recipient = 'order@brainr.co'

			$.ajax
				type: 'POST'
				url: 'https://mandrillapp.com/api/1.0/messages/send.json'
				data:
					key: 'iAYRb74rpCJ5Jdfc3Y1O9w'
					message:
						html: createHtml(data)
						subject: subject
						from_email: data['email'],
						from_name: data['name'],
						to: [
							email: recipient
							name: 'Brainr Administration'
						]
				beforeSend: ->
					$('button i', self).addClass 'fa-refresh fa-spin'
					$('button span', self).text 'Küldés...'
				complete: ->
					$('button i', self).removeClass 'fa-refresh fa-spin'
					$(self).data 'sent', 1
				success: ->
					$('button', self)
					.removeClass 'btn-primary'
					.addClass 'btn-success'

					$('button span', self).text 'Köszönjük érdeklődését!'
				error: ->
					mailBody = """
Kedves Brainr!%0A
%0A
Az alábbiak iránt érdeklődöm:%0A
#{data['comment']}%0A
%0A
Üdvözlettel,%0A
#{data['name']}
"""
					$('button i', self).removeClass 'fa-refresh fa-spin'
					$('button span', self).text 'Hiba történt, kérjük kattintson ide újra a manuális küldéshez!'

					$('button', self)
					.changeElementType 'a'
					.removeClass 'btn-primary'
					.addClass 'btn-danger'

					$('.submit', self)
					.attr 'href', "mailto:#{recipient}?subject=#{subject}&body=#{mailBody}"
					.on 'click', ->
						$(@)
						.removeClass 'btn-danger'
						.addClass 'btn-success'
						$('span', @).text 'Köszönjük érdeklődését!'
					return


		e.preventDefault()
		e.stopPropagation()
		false
	@

