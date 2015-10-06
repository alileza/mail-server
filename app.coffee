http = require "http"
express = require 'express'
bodyParser = require 'body-parser'
Settings = require 'settings'
CONFIG = new Settings require('./config')

winston = require 'winston'

winston.loggers.add 'log', console: colorize: true

log = winston.loggers.get 'log'


Mandrill = require './parties/Mandrill.coffee'

app = express()
app.use bodyParser.json()


app.post '/send-mail', (req, res) ->
	
	{ body } = req

	mail = new Mandrill CONFIG.mandrill

	mail.setOptions body

	mail.send (error, response) ->
		if error
			return res.status(400).send { message: error }
		
		return res.send response


app.listen CONFIG.port
log.info "Mail server start at port #{CONFIG.port}"