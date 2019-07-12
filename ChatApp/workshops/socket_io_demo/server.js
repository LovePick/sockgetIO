var app = require('express')();
var http = require('http').createServer(app);
var io = require('socket.io')(http);

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});

io.on('connect',
    function (socket) {
        console.log('a user connected');
        socket.broadcast.emit('hi');

        socket.on('chat message', function (msg) {
            console.log('message: ' + msg);
            io.emit('chat message', msg);
        });

        socket.on('jsonTest', function (msg) {
            console.log('message: ' + msg);
            io.emit('chat message', msg['name']);
        });
    }
);

http.listen(3000, function () {
    console.log('listening on *:3000');
}
);