require('dotenv').config()

const express = require('express')
const app = express()
const mongoose  = require('mongoose')
const http = require('http').createServer(app)
const io = require('socket.io')(http, { cors : { origin : "*" } });
const message = require('./models/message.model');
const DM = require('./models/dm.model')
const conversation = require('./models/conversation.model')
const user = require('./models/users.model');
const https = require('https')
const fs = require('fs')

const HTTP_PORT = process.env.PORT || 3000
//const HTTPS_PORT = process.env.HTTPS_PORT || 3001

// Define the first route
app.get("/", function (req, res) {
    res.send("Welcome to Hermes")
})

try{

    mongoose.connect(process.env.DATABASE_URL)
    const db = mongoose.connection
    db.once('open', () => console.log('Connected to database'))
    db.on('error', (error) => console.log(error))

} catch (err){

    console.log(err.message)
}


app.use(express.json())

const userRouter = require('./routes/userService')
app.use('/api/userService/', userRouter)

const events = require('./routes/events')
app.use('/api/events/', events)

const channels = require('./routes/channels')
app.use('/api/channels/', channels)

const roles = require('./routes/roles')
app.use('/api/roles/', roles)

const messages = require('./routes/messages.js')
app.use('/api/messages/', messages)

const convo = require('./routes/convos')
app.use('/api/conversations/', convo)

const dm = require('./routes/dms')
app.use('/api/dms/', dm)

const members = require('./routes/members')
app.use('/api/members/', members)


var https_options = {
    key: fs.readFileSync('./security/cert.key'),
    cert: fs.readFileSync('./security/cert.pem')
};

const insert = async (sender, body, room, timestamp) => {
    const dm = await DM.findById(room);
    const senderID = await user.findOne({ username : sender })
    const newmess = new message({
        senderID: senderID,
        body: body,
        timeStamp: timestamp,
    })

    const mess = await newmess.save();
    dm['messages'].push(mess._id)
    await dm.save()
}

const insertChan = async (sender, body, room, timestamp) => {
    const grp = room.split('-')
    const convo = await conversation.findById(grp[0]);

    const senderID = await user.findOne({ username : sender })

    console.log('mongo query', room, sender)

    const newmess = new message({
        senderID: senderID._id,
        body: body,
        timeStamp: timestamp,
    })
    const mess = await newmess.save();
    console.log("insertChan",mess)
    for(var i = 0 ; i < convo['channels'].length ; i++){
        if(convo['channels'][i]['name'] == grp[1]){
            convo['channels'][i]['messages'].push(mess._id);
            await convo.save();
            return;
        }
    }


}

    io.on('connection', socket => {

        console.log('connected socket: ', socket.id)
        socket.on('connectDM', (dmid) => {
            socket.join(dmid['dmid']);
            console.log('connectDM', dmid)
        })

        socket.on('connectChan', (room) => {
            socket.join(room['room']);
            console.log(room)
        })

        socket.on('sendChan', message => {

            room = message.room
            sender = message.sender
            text = message.text
            console.log(message)
            //Get time
            let datetime = new Date(Date.now())
            let timestamp = datetime.toISOString().split('.')[0]

            insertChan(sender, text, room, timestamp)

            socket.to(room).emit('recvChan', {
                senderID: sender,
                body: text,
                timestamp: timestamp
            })
        })

        socket.on('sendDM', message => {

            room = message.room
            sender = message.sender
            text = message.text
            console.log(message)
            
            //Get time
            let datetime = new Date(Date.now())
            let timestamp = datetime.toISOString().split('.')[0]

            insert(sender, text, room, timestamp)

            socket.in(room).emit('recvDM', {
                senderID: sender,
                body: text,
                timestamp: timestamp
            })

        })
        socket.on('disconnect', () => {
            console.log('removing user')
        })
    })

const httpServer = http.listen(HTTP_PORT, (err) => {
    
    if(err){
        console.log(err.message)
        return
    }
    console.log(`HTTP Server Started at port ${HTTP_PORT}/`)
})

/*
const httpsServer = https.createServer(https_options, app).listen(HTTPS_PORT, (err) => {
    
    if(err){
        console.log(err.message)
        return
    }
    console.log(`HTTPS Server Started at http://localhost:${HTTPS_PORT}/`)
})
*/

module.exports = httpServer