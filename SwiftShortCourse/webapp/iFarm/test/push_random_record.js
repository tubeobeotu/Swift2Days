'use strict';

let app = require('../server-test');
let Promise = require('arrowjs').Promise;
var request = require('request-promise');

setInterval(function () {
    Promise.coroutine(function *() {
        let sensors = yield app.models.sensor.findAll();
        let record = sensors.map(function (sensor) {
            return {
                sensorId: sensor.id,
                pH: 1 + Math.random() * 6,
                temperature: Math.floor(Math.random() * 100),
                moisture: Math.floor(Math.random() * 100),
                battery: Math.floor(Math.random() * 100),
                note: "Thế hâm hấp"
            }
        });

        var option = {
            method: 'POST',
            uri: app.getConfig('domain') + "/api/record/create",
            body: record,
            json: true // Automatically stringifies the body to JSON
        };

        return request(option);
    })()
}, 1000); // 1 seconds


