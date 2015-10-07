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

		@errors= []

		@params["headers"] =
            "Reply-To": @params.from_email

	required: ['to', 'from_email', 'subject', 'template']

	send: (cb) ->
		if @validate()
			@mandrill '/messages/send', { message: @params }, (error, response) ->
				if error
					return cb error
					
				try
					delete @params.html
				
				return cb null, 
						message : 'success'
						payload : @params
		else
			return cb @errors
			

	validate: () ->
		@required.forEach (key) =>
			@errors.push "#{key} not defined" if typeof @params?[key] is 'undefined'
			@errors.push "#{key} can not be empty" if @params?[key]?.length is 0

		return if @errors.length is 0 then true else false

	set: (key, value) -> 
		@params[key] = value
		return @

	setOptions: (body) =>
		for key of body
			@set key, body[key]
		@addRecipients body.to
		@setTemplate body.template if body.template
		return @

	setTemplate: (key) ->
		try
			text = fs.readFileSync("email-template/#{key}/text.ejs").toString()
		catch e
			@errors.push "template #{key} not exists, make sure put file `text.ejs` inside folder `email-template/#{key}/`"
			return @
		
		try
			text = ejs.render text, @params
		catch e
			@errors.push "failed to render `#{key}/text.ejs` make sure parameter fills all the requirement : #{e}"
			return @

		@params['text'] = text

		try
			html = fs.readFileSync("email-template/#{key}/html.ejs").toString()
		catch e
			@errors.push "template #{key} not exists, make sure put file `html.ejs` inside folder `email-template/#{key}/`"
			return @

		try
			html = ejs.render html, @params
		catch e
			@errors.push "failed to render `#{key}/html.ejs` make sure parameter fills all the requirement : #{e}"
			return @
		

		@params['html'] = html

		@params.template = key

		return @


	addRecipients: (users) ->
		@params.to = [] if typeof @params.to isnt 'object'
		
		# if and only if user give strign to 
		if typeof users is "string"
			@params.to.push { email: users }
			return @
		else if typeof users is "object"
			users.forEach (user) =>
				u = {}
				u.email = user if typeof user is 'string'
				u.email = user.email if user.email
				u.name = user.name if user.name

				@params.to.push u
			
		return @

module.exports = Mandrill