var io = require('socket.io').listen(8000);

// open the socket connection
io.sockets.on('connection', function (socket) {

    // listen for the chat even. and will recieve
    // data from the sender.
    setInterval(function(){
        socket.emit('updatingSensort', {
            name: "Sensor1",
            temp: Math.random()
        });
    }, 500);

});