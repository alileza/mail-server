http = require "http"
Mandrill = require './parties/Mandrill.coffee'
express = require 'express'
bodyParser = require 'body-parser'

app = express()
app.use bodyParser.json()

mail = new Mandrill
	apiKey: require('./.env').apiKey
	default: 
		from_email: 'example@example.com'
		from_name: 'Example'
		tags: ['tes']

app.post '/send-mail', (req, res) ->
	
	{ body } = req

	mail.addRecipients body.to
	mail.set 'from_email', body.from_email if body.from_email
	mail.set 'from_name', body.from_name if body.from_name
	mail.set 'tags', body.tags if body.tags
	mail.set 'subject', body.subject if body.subject
	mail.setTemplate body.template if body.template

	mail.validate (error) =>
		if error
			return res.send
				code : 400
				message: error
		
		mail.send()
		res.send
			code : 200
			message : 'sucess'

app.listen 8088