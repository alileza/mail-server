setEnvironment = () ->
	try
		return require "./.env"
	catch e
		exec = require('child_process').exec
		if e.code is 'MODULE_NOT_FOUND'
			exec 'cp ./.env-example ./.env'
		return require "./.env-example"

ENV = setEnvironment()

module.exports =
	common: 
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