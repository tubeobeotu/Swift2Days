/**
 * Created by chotoxautinh on 8/18/16.
 */
var socket = require('socket.io');
var logger = require('arrowjs').logger;

function SocketManager(serverSocket, app) {
    let self = this;
    self.io = socket.listen(serverSocket);

    self.io.on('connection', function (client) {

        let user_id;

        client.on('join', function (userId) {
            user_id = userId;
            logger.info("SOCKET: User " + userId + " connected with id " + client.id);
            client.join(userId);
        });

        client.on('disconnect', function () {
            if (user_id)
                logger.info("SOCKET: User " + user_id + " disconnected with id " + client.id);
        });

        client.on('push_data', function (sensor_data) {
            let sensor_id = sensor_data.sensorId;
            app.models.sensor.findById(sensor_id).then(function (sensor) {
                let userId = sensor.createdBy;
                if (self.io.nsps["/"].adapter.rooms[userId]) {
                    Object.keys(self.io.nsps["/"].adapter.rooms[userId].sockets).forEach(function (socket) {
                        logger.info(socket);
                    });
                    client.to(userId).emit('pull_data', sensor_data);
                }
                // self.io.emit('pull_data', sensor_data);
            });
        });

    });
}

module.exports = function (serverSocket, app) {
    return new SocketManager(serverSocket, app);
};
