/**
 * Created by chotoxautinh on 9/7/16.
 */

let logger = require('arrowjs').logger;
let Promise = require('arrowjs').Promise;
let io = require('socket.io-client');

module.exports = function (controller, component, app) {

    controller.receiveRecord = function (req, res) {
        Promise.coroutine(function*() {
            var socket = io.connect("http://localhost:" + app.getConfig('socket_port'), {reconnect: true});
            let record = req.body;

            yield Promise.map(record, function (data) {
                return Promise.all([
                    (function () {
                        socket.emit('push_data', data);
                    }()),
                    app.models.sensor_data.create(data)
                ]).catch(function (err) {
                    logger.error(err);
                })
            });
            let deleteQuery = `delete from sensor_data 
                                where id in (select id from 
                                                (select id, ROW_NUMBER() over (order by id desc) as row from sensor_data) AS sd 
                                            where row > 10000)`;
            yield app.models.rawQuery(deleteQuery);

            res.sendStatus(200);
        })();
    }
}