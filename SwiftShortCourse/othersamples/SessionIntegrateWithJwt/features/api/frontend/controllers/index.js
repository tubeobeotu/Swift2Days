'use strict';

let Promise = require('arrowjs').Promise;
let passport = require('passport');
let jwt = require('jsonwebtoken');

let form = require(__base + '/library/js_utilities/formidablePromise');
let fs = Promise.promisifyAll(require("fs"));
let logger = require('arrowjs').logger;

module.exports = function (controller, component, app) {

    controller.login = function (req, res) {
        passport.authenticate('local', {session: false}, function (err, user, info) {

            if (err) {
                return res.status(500).json({error: err.message});
            }
            if (!user) {
                return res.status(403).json({error: info.message});
            }

            app.feature.users.actions.generateToken(user.id)
                .then(function (result) {
                    res.json(result);
                }).catch(function (err) {
                logger.error(err);
                res.send(500).json(err);
            })

        })(req, res);
    }

    controller.refreshToken = function (req, res) {
        let auth_header = req.headers.authorization;
        if (!auth_header)
            return res.sendStatus(400);
        let authScheme = app.getConfig('authScheme');
        if (!auth_header.startsWith(authScheme))
            return res.sendStatus(400);
        let accessToken = auth_header.replace(authScheme + ' ', '');
        try {
            var jwtPayload = jwt.verify(accessToken, app.getConfig('restApiKey'), {ignoreExpiration: true});

        } catch (err) {
            return res.status(403).json(err);
        }
        Promise.coroutine(function *() {
            let user_token = yield app.models.userToken.find({
                where: {
                    userId: jwtPayload.id,
                    jwtId: jwtPayload.jti,
                    refresh_token: req.body.refreshToken,
                    refresh_token_expires: {
                        $gt: Date.now()
                    }
                }
            });
            if (!user_token)
                return res.status(403).json({
                    message: 'Token không hợp lệ hoặc đã hết hạn'
                });

            let result = yield app.feature.users.actions.generateToken(jwtPayload.id);
            res.json(result);

        })().catch(function (err) {
            logger.error(err);
            res.status(500).json(err);
        })

    }

    controller.imageList = function (req, res) {
        app.models.image.findAll().then(function (results) {
            res.json(results);
        }).catch(function (err) {
            logger.error(err);
            res.send(500).json(err);
        });
    }

    controller.createImage = function (req, res) {
        Promise.coroutine(function*() {
            let dirPath = __base + '/upload/media/';
            let relative = '/media/';

            try {
                fs.accessSync(dirPath, fs.F_OK);
            } catch (e) {
                fs.mkdirSync(dirPath);
            }

            let result = yield form.parseAsync(req);
            let data = result[0];
            let files = result[1];

            let name = data.name;
            let fileName = files.photofile.name;

            let ext = '';
            if (fileName.split('.').length > 1)
                ext = '.' + fileName.split('.').pop();

            let image = yield app.models.image.create({
                name: name
            });
            yield fs.renameAsync(files.photofile.path, dirPath + image.id + ext);


            yield image.update({
                photofile: relative + image.id + ext
            });

            res.send(image);
        })().catch(function (err) {
            logger.error(err);
            res.sendStatus(500);
        })
    }
};