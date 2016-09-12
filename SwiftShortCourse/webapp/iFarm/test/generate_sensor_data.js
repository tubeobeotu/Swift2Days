'use strict';

let app = require('../server-test');
let Promise = require('arrowjs').Promise;

Promise.coroutine(function *() {
    let farms = yield app.models.farm.findAll();

    yield Promise.map(farms, function (farm) {
        return app.models.sensor.create({
            id: "Sensor" + Math.floor(Math.random() * 1000),
            farmId: farm.id,
            description: "DM The",
            createdBy: farm.owner
        }).then(function (sensor) {
            return app.models.sensor_data.create({
                sensorId: sensor.id,
                pH: 1 + Math.random() * 6,
                temperature: Math.floor(Math.random() * 100),
                moisture: Math.floor(Math.random() * 100),
                battery: Math.floor(Math.random() * 100),
                note: "Nhu long"
            })
        })
    });
})().then(function () {
    console.log("\x1b[32m", 'Done.', "\x1b[0m");
    process.exit();
}).catch(function (err) {
    console.log("\x1b[31m", err, "\x1b[0m");
    process.exit();
});


