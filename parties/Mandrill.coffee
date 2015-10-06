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

	required: ['recipients', 'from_email', 'subject', 'text', 'html']

	send: () ->
		self = @
		@validate (response) ->
			if response
				err = new Error response
				throw err
			
			self.mandrill '/messages/send', { message: self.params }, (error, response) ->
				if error
					err = new Error JSON.stringify error
					throw err

				console.log 'response'
				console.log response

	validate: (cb) ->
		self = @
		@required.forEach (key) ->
			return cb "#{key} not defined" if typeof self.params?[key] is 'undefined'

		cb null

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

	addRecipient: (user) ->
		@params.recipients = [] if typeof @params.recipients isnt 'object'

		@params.recipients.push
			email: user.email
			name: if user.name then user.name else user.email
		return @

module.exports = Mandrill