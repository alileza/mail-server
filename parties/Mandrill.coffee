console.time "loadLibraries"
ejs = require('ejs')
ejs.open = '{{'
ejs.close = '}}'
fs = require 'fs'
console.timeEnd "loadLibraries"

class Mandrill
	constructor: (config) ->
		{ apiKey } = config
		@mandrill = require('node-mandrill') apiKey
		@params = config.default

		@params["headers"] =
            "Reply-To": @params.from_email

	required: ['to', 'from_email', 'subject', 'text', 'html']

	send: () ->
		@validate (response) =>
			if response
				err = new Error response
				throw err
			
			@mandrill '/messages/send', { message: @params }, (error, response) ->
				if error
					err = new Error JSON.stringify error
					throw err

				console.log 'response'
				console.log response

	validate: (cb) ->
		@required.forEach (key) =>
			return cb "#{key} not defined" if typeof @params?[key] is 'undefined'
		return cb null, true
	set: (key, value) -> 
		@params[key] = value
		return @

	setTemplate: (key) -> 
		text = fs.readFileSync("email-template/#{key}/text.ejs").toString()
		text = ejs.render text, @params
		@params['text'] = text

		html = fs.readFileSync("email-template/#{key}/html.ejs").toString()
		html = ejs.render html, @params
		@params['html'] = html
		return @


	addRecipients: (users) ->
		@params.to = [] if typeof @params.to isnt 'object'
		
		# if and only if user give strign to 
		if typeof users is "string"
			@params.to.push { email: body.to }
			return @

		users.forEach (user) =>
			u =
				email: user.email	
			u.name = user.name if user.name

			@params.to.push u
			
		return @

module.exports = Mandrill