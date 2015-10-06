module.exports =
	common: 
		port: 1312
		mandrill: 
			apiKey: require('./.env').apiKey
			default:
				from_email: 'example@example.com'
				from_name: 'Example'
				tags: ['tes']

	development: {}
	test: {}
	production: {} 