/**
 * Created by chotoxautinh on 9/7/16.
 */

let logger = require('arrowjs').logger;
let Promise = require('arrowjs').Promise;
let fs = Promise.promisifyAll(require("fs"));
let _ = require('arrowjs')._;

module.exports = function (controller, component, app) {

    controller.list = function (req, res) {
        Promise.coroutine(function*() {
            let condition = ArrowHelper.filterRequest(req, app);
            if (req.permissions.indexOf("manage_all_farms") == -1) {
                if (!condition.hasOwnProperty("where")) {
                    condition.where = {};
                }
                Object.assign(condition.where, {
                    owner: req.user.id
                });
            }
            if (!condition.hasOwnProperty("order")) {
                condition.order = [['createdAt', 'desc']];
            }
            let farms = yield app.models.farm.findAll(condition);
            yield Promise.map(farms, function (farm) {
                return app.models.sensor.findAll({
                    where: {
                        farmId: farm.id
                    },
                    include: [{
                        model: app.models.sensor_data,
                        order: [['createdAt', 'desc']],
                        limit: 1,
                        require: false
                    }]
                }).then(function (sensors) {
                    farm.dataValues.sensorCount = sensors.length;
                    sensors = sensors.filter(function (sensor) {
                        return sensor.sensor_data.length > 0;
                    })
                    sensors = _.sortBy(sensors, function (sensor) {
                        return sensor.sensor_data.createdAt;
                    });
                    if (sensors.length && sensors[sensors.length - 1].sensor_data.length) {
                        var lastModified = sensors[sensors.length - 1].sensor_data[0].createdAt;
                    } else
                        var lastModified = null;
                    farm.dataValues.lastModified = lastModified;
                    return farm;
                });
            });
            res.json(farms);
        })().catch(function (err) {
            res.status(400).json({
                name: err.name,
                message: err.message
            });
        });
    }

    controller.farmRead = function (req, res, next) {
        Promise.coroutine(function *() {
            let farm = yield app.models.farm.find({
                where: {
                    id: req.params.farmId
                }
            });
            if (!farm)
                return res.sendStatus(404);
            let sensors = yield app.models.sensor.findAll({
                where: {
                    farmId: req.params.farmId
                },
                include: [{
                    model: app.models.sensor_data,
                    order: [['createdAt', 'desc']],
                    limit: 1,
                    require: false
                }]
            });
            farm.dataValues.sensorCount = sensors.length;
            sensors = sensors.filter(function (sensor) {
                return sensor.sensor_data;
            })
            sensors = _.sortBy(sensors, function (sensor) {
                if (sensor.sensor_data)
                    return sensor.sensor_data.createdAt;
                return null;
            });
            if (sensors.length && sensors[sensors.length - 1].sensor_data)
                var lastModified = sensors[sensors.length - 1].sensor_data.createdAt;
            else
                var lastModified = null;
            farm.dataValues.lastModified = lastModified;
            req.farm = farm;
            next();

        })().catch(function (err) {
            logger.error(err);
            return res.sendStatus(500);
        });
    }

    controller.view = function (req, res) {
        if (req.permissions.indexOf("manage_all_farms") == -1 && req.farm.owner != req.user.id)
            return res.sendStatus(404);
        res.json(req.farm);
    }

    controller.update = function (req, res) {
        if (req.permissions.indexOf("manage_all_farms") == -1 && req.farm.owner != req.user.id)
            return res.sendStatus(404);
        Promise.coroutine(function*() {
            let result = yield ArrowHelper.parseRequest(req);
            let data = result[0];
            data.owner = req.user.id;
            let files = result[1];
            let farm = req.farm;

            let updateData = data;
            let file = files.image;

            if (file) {
                let fileName = file.name;
                let dirPath = __base + '/upload/img/farm/';
                let relative = '/img/farm/';

                try {
                    fs.accessSync(dirPath, fs.F_OK);
                } catch (e) {
                    fs.mkdirSync(dirPath);
                }

                let ext = '';
                if (fileName.split('.').length > 1)
                    ext = '.' + fileName.split('.').pop();

                yield fs.renameAsync(file.path, dirPath + farm.id + ext);
                Object.assign(updateData, {
                    image: relative + farm.id + ext
                });
            }

            yield farm.update(updateData);
            res.json(farm);
        })().catch(function (err) {
            if (err.name == "SequelizeDatabaseError") {
                return res.status(400).json({
                    name: err.name,
                    message: err.message
                });
            }
            logger.error(err);
            res.sendStatus(500);
        });
    }

    controller.delete = function (req, res) {
        let farm = req.farm;
        if (req.permissions.indexOf("manage_all_farms") == -1 && farm.owner != req.user.id)
            return res.sendStatus(404);
        return farm.destroy()
            .then(function () {
                res.json(farm);
            }).catch(function (err) {
                logger.error(err);
                return res.sendStatus(500);
            });
    }

    controller.create = function (req, res) {
        Promise.coroutine(function*() {
            let result = yield ArrowHelper.parseRequest(req);
            let data = result[0];
            data.owner = req.user.id;
            let files = result[1];
            let farm = yield app.models.farm.create(data);

            let file = files.image;

            if (file) {
                let fileName = file.name;
                let dirPath = __base + '/upload/img/farm/';
                let relative = '/img/farm/';

                try {
                    fs.accessSync(dirPath, fs.F_OK);
                } catch (e) {
                    fs.mkdirSync(dirPath);
                }

                let ext = '';
                if (fileName.split('.').length > 1)
                    ext = '.' + fileName.split('.').pop();

                yield fs.renameAsync(file.path, dirPath + farm.id + ext);
                yield farm.update({
                    image: relative + farm.id + ext
                });
            }
            res.send(farm);
        })().catch(function (err) {
            if (err.name == "SequelizeDatabaseError") {
                return res.status(400).json({
                    name: err.name,
                    message: err.message
                });
            }
            logger.error(err);
            res.sendStatus(500);
        });
    }

    controller.addSensor = function (req, res) {
        let data = req.body;
        Object.assign(data, {createdBy: req.user.id});
        return app.models.sensor.create(data).then(function (sensor) {
            res.json(sensor);
        }).catch(function (err) {
            if (err.name == "SequelizeUniqueConstraintError") {
                logger.error(err);
                return res.status(400).json({
                    name: err.name,
                    message: err.message
                });
            }
            logger.error(err);
            res.sendStatus(500);
        })
    }

}