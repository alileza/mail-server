Mandrill = require './parties/Mandrill.coffee'

mail = new Mandrill
			apiKey: require('./.env').apiKey
			default: 
				from_email: 'example@example.com'
				from_name: 'Example'
				tags: ['tes']

mail.addRecipient { email: "alirezayahya@gmail.com" }
mail.set 'subject', 'hello world'
mail.setTemplate 'hello-world'
mail.send()




