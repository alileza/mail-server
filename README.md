# mail-server

easy install `git clone https://github.com/alileza/mail-server.git && cd mail-server && npm install && npm start`

test the mail server

`curl -X POST  -H "Content-Type: application/json" http://localhost:1312/send-mail -d '{"to": "alirezayahya@gmail.com","subject": "Hello World !","template" : "hello-world"}'`

