setEnvironment = () ->
	try
		return require "./.env"
	catch e
		fs = require 'fs'
		
		readlineSync = require('readline-sync')

		apiKey = readlineSync.question('Please input Mandrill API Key : ')
		fs.writeFileSync './.env', "exports.apiKey = '#{apiKey}'", 'utf-8'
		return { apiKey: apiKey }

ENV = setEnvironment()

module.exports =
	common: 
		host: 'localhost'
		port: 1312
		mandrill: 
			apiKey: ENV.apiKey
			default:
				from_email: 'example@example.com'
				from_name: 'Example'
				tags: ['tes']

	development: {}
	test: {}
	production: {} 