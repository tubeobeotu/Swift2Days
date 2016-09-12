/**
 * Created by chotoxautinh on 9/7/16.
 */

let logger = require('arrowjs').logger;

module.exports = function (controller, component, app) {

    controller.list = function (req, res) {
        try {
            let condition = ArrowHelper.filterRequest(req, app);
            if (req.permissions.indexOf("manage_all_sensors") == -1) {
                if (!condition.hasOwnProperty("where")) {
                    condition.where = {};
                }
                Object.assign(condition.where, {
                    createdBy: req.user.id
                });
            }
            if (!condition.hasOwnProperty("order")) {
                condition.order = [['createdAt', 'desc']];
            }

            Object.assign(condition, {
                include: [{
                    model: app.models.sensor_data,
                    order: [['createdAt', 'desc']],
                    limit: 1,
                    require: false
                }]
            });
            return app.models.sensor.findAll(condition)
                .then(function (sensors) {
                    res.json(sensors);
                }).catch(function (err) {
                    res.status(400).json({
                        name: err.name,
                        message: err.message
                    });
                });
        } catch (err) {
            logger.error(err);
            return res.sendStatus(500);
        }
    }

    controller.sensorRead = function (req, res, next) {
        return app.models.sensor.find({
            where: {
                id: req.params.sensorId,
            },
            include: [{
                model: app.models.sensor_data,
                order: [['createdAt', 'desc']],
                limit: 1,
                require: false
            }]
        }).then(function (sensor) {
            if (!sensor)
                return res.sendStatus(404);
            req.sensor = sensor;
            next();
        }).catch(function (err) {
            logger.error(err);
            return res.sendStatus(500);
        })
    }

    controller.view = function (req, res) {
        if (req.permissions.indexOf("manage_all_sensors") == -1 && req.sensor.createdBy != req.user.id)
            return res.sendStatus(404);
        res.json(req.sensor);
    }

    controller.update = function (req, res) {
        if (req.permissions.indexOf("manage_all_sensors") == -1 && req.sensor.createdBy != req.user.id)
            return res.sendStatus(404);
        let data = req.body;
        let sensor = req.sensor;
        return sensor.update(data)
            .then(function () {
                res.json(sensor);
            }).catch(function (err) {
                res.status(400).json({
                    name: err.name,
                    message: err.message
                });
            });
    }

    controller.delete = function (req, res) {
        if (req.permissions.indexOf("manage_all_sensors") == -1 && req.sensor.createdBy != req.user.id)
            return res.sendStatus(404);
        let sensor = req.sensor;
        return sensor.destroy()
            .then(function () {
                res.json(sensor);
            }).catch(function (err) {
                logger.error(err);
                return res.sendStatus(500);
            })
    }
}