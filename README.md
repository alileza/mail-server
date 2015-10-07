# Mail Server

This mail server build using NodeJS (coffeescript) currently only support using **[Mandrill](https://mandrill.com)**, the goal of this application is to support massive external communication such an E-mail, Messaging, & Push Notification. Roadmap of this service would include : (Queueing, Template Manager, & Monitoring)

### Installation
```sh
$ git clone https://github.com/alileza/mail-server.git
$ cd mail-server
$ npm install 
$ npm start
```
### Test the mail server
```sh
curl -X  POST  -H "Content-Type: application/json" \
http://localhost:1312/send-mail -d \
'{"to": "alirezayahya@gmail.com","subject": "Hello World !","template" : "hello-world"}'
```

### Mail Client
[NodeJS Mail Client](https://github.com/alileza/mail-client)
