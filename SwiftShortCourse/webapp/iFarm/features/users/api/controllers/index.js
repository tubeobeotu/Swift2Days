/**
 * Created by chotoxautinh on 9/9/16.
 */

let logger = require('arrowjs').logger;
let Promise = require('arrowjs').Promise;
let fs = Promise.promisifyAll(require("fs"));
let randomBytesAsync = Promise.promisify(require('crypto').randomBytes);
let validator = require('validator');

module.exports = function (controller, component, app) {

    controller.list = function (req, res) {
        try {
            let condition = ArrowHelper.filterRequest(req, app);
            if (!condition.hasOwnProperty("order")) {
                condition.order = [['user_registered', 'desc']];
            }
            return app.models.user.findAll(condition)
                .then(function (users) {
                    res.json(users);
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

    controller.create = function (req, res) {


        Promise.coroutine(function*() {
            let data = req.body;

            if (data.image) {
                let mime = data.image.match(/^data:image\/(jpg|jpeg|png);base64,/);
                if (!mime || !mime.length)
                    return res.status(400).json({
                        message: "Invalid Image Type"
                    });

                var ext = mime[1];
                var base64Data = data.image.replace(/^data:image\/(jpg|jpeg|png);base64,/, "");
            }

            let user = yield app.models.user.create(data);
            if (data.image) {
                let relative = '/img/user/';
                let fileName = relative + user.id + '.' + ext;

                let dirPath = __base + '/upload/img/user/';
                try {
                    fs.accessSync(dirPath, fs.F_OK);
                } catch (e) {
                    fs.mkdirSync(dirPath);
                }

                yield writeFileAsync(dirPath + user.id + '.' + ext, base64Data, 'base64');

                yield user.update({
                    user_image_url: fileName
                });
            }

            res.send(user);
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

    controller.viewUser = function (req, res) {
        app.models.user.findById(req.user.id)
            .then(function (user) {
                res.json(user);
            });
    }

    controller.updateUser = function (req, res) {
        Promise.coroutine(function*() {
            let user = yield app.models.user.findById(req.user.id);
            let data = req.body;

            if (data.hasOwnProperty("user_pass"))
                delete data.user_pass;

            if (data.image) {
                let mime = data.image.match(/^data:image\/(jpg|jpeg|png);base64,/);
                if (!mime || !mime.length)
                    return res.status(400).json({
                        message: "Invalid Image Type"
                    });

                let ext = mime[1];
                let base64Data = data.image.replace(/^data:image\/(jpg|jpeg|png);base64,/, "");
                let relative = '/img/user/';
                let fileName = relative + user.id + '.' + ext;

                let dirPath = __base + '/upload/img/user/';
                try {
                    fs.accessSync(dirPath, fs.F_OK);
                } catch (e) {
                    fs.mkdirSync(dirPath);
                }

                yield writeFileAsync(dirPath + user.id + '.' + ext, base64Data, 'base64');

                data.user_image_url = fileName;
            }

            yield user.update(updateData);
            res.json(user);
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

    controller.update = function (req, res) {
        Promise.coroutine(function*() {
            let user = req._user;
            let data = req.body;

            if (data.hasOwnProperty("user_pass"))
                delete data.user_pass;

            if (data.image) {
                let mime = data.image.match(/^data:image\/(jpg|jpeg|png);base64,/);
                if (!mime || !mime.length)
                    return res.status(400).json({
                        message: "Invalid Image Type"
                    });

                let ext = mime[1];
                let base64Data = data.image.replace(/^data:image\/(jpg|jpeg|png);base64,/, "");
                let relative = '/img/user/';
                let fileName = relative + user.id + '.' + ext;

                let dirPath = __base + '/upload/img/user/';
                try {
                    fs.accessSync(dirPath, fs.F_OK);
                } catch (e) {
                    fs.mkdirSync(dirPath);
                }

                yield writeFileAsync(dirPath + user.id + '.' + ext, base64Data, 'base64');

                data.user_image_url = fileName;
            }

            yield user.update(updateData);
            res.json(user);
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

    controller.updatePass = function (req, res) {
        Promise.coroutine(function*() {
            let user = yield app.models.user.find({
                where: {
                    id: req.user.id
                }
            });
            let old_pass = req.body.old_pass.trim();
            let user_pass = req.body.user_pass.trim();

            if (user.authenticate(old_pass)) {
                yield user.update({
                    user_pass: user.hashPassword(user_pass)
                });
                res.sendStatus(200);
            } else {
                res.status(400).json({
                    message: 'Invalid Password'
                })
            }
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

    controller.updateEmail = function (req, res) {
        Promise.coroutine(function*() {
            let user = req.user;
            let new_email = req.body.email.trim();

            if (validator.isEmail(new_email)) {
                let existUser = yield app.models.user.find({
                    where: {
                        user_email: new_email
                    }
                });
                if (existUser) {
                    return res.status(400).json({
                        message: 'Email has existed'
                    })
                }
                let tokenBuffer = yield randomBytesAsync(20);
                let token = tokenBuffer.toString('hex');

                let user_token = yield app.models.user_token.find({
                    where: {
                        user_id: user.id
                    }
                });

                if (user_token) {
                    if (Date.now() > user_token.change_email_expires && user_token.change_email != new_email) {
                        yield user_token.update({
                            change_email: new_email,
                            change_email_token: token,
                            change_email_expires: Date.now() + 15 * 60 * 1000
                        });
                    }
                } else {
                    user_token = yield app.models.user_token.create({
                        user_id: user.id,
                        change_email: new_email,
                        change_email_token: token,
                        change_email_expires: Date.now() + 15 * 60 * 1000
                    });
                }

                return res.api.render('mail_tpl/change_email', {
                    old_email: user.user_email,
                    new_email: new_email,
                    user_id: user.id,
                    token: user_token.change_email_token
                }, function (err, emailHTML) {
                    if (err) {
                        logger.error(err);
                    } else {
                        // Send email
                        let mailOptions = {
                            from: app.getConfig('mailer_from'), // sender address
                            to: user.user_email,
                            replyTo: app.getConfig('mailer_reply'),
                            subject: app.getConfig('app.title') + ': Xác nhận đổi email',
                            html: emailHTML
                        };
                        ArrowHelper.sendMail(app, mailOptions);
                        return res.sendStatus(200);
                    }
                });
            } else {
                res.status(400).json({
                    message: 'Invalid Email'
                })
            }
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

    controller.retrievePass = function (req, res) {
        Promise.coroutine(function*() {
            let user_email = req.body.email.trim();
            let user = yield app.models.user.find({
                where: {
                    user_email: user_email
                }
            });

            if (!user) {
                res.sendStatus(404);
            }

            let tokenBuffer = yield randomBytesAsync(20);
            let token = tokenBuffer.toString('hex');

            let user_token = yield app.models.user_token.find({
                where: {
                    user_id: user.id
                }
            });

            if (user_token) {
                if (Date.now() > user_token.reset_password_expires) {
                    yield user_token.update({
                        reset_password_token: token,
                        reset_password_expires: Date.now() + 15 * 60 * 1000
                    });
                }
            } else {
                user_token = yield app.models.user_token.create({
                    user_id: user.id,
                    reset_password_token: token,
                    reset_password_expires: Date.now() + 15 * 60 * 1000
                });
            }

            return res.api.render('mail_tpl/retrieve_password', {
                user_email: user.user_email,
                user_id: user.id,
                token: user_token.reset_password_token
            }, function (err, emailHTML) {
                if (err) {
                    logger.error(err);
                } else {
                    // Send email
                    let mailOptions = {
                        from: app.getConfig('mailer_from'), // sender address
                        to: user.user_email,
                        replyTo: app.getConfig('mailer_reply'),
                        subject: app.getConfig('app.title') + ': Xác nhận reset mật khẩu',
                        html: emailHTML
                    };
                    ArrowHelper.sendMail(app, mailOptions);
                    return res.sendStatus(200);
                }
            });
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

    controller.userById = function (req, res, next) {
        app.models.user.find({
            where: {id: req.params.uid}
        }).then(function (user) {
            if (user) {
                req._user = user;
                next();
            } else {
                res.sendStatus(404);
            }
        }).catch(function (err) {
            logger.error(err);
            res.sendStatus(500);
        });
    }

    controller.view = function (req, res) {
        res.json(req._user);
    }

}