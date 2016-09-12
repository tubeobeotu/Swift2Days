'use strict';

let Promise = require('arrowjs').Promise;
let passport = require('passport');
let randomBytesAsync = Promise.promisify(require('crypto').randomBytes);
let jwt = require('jsonwebtoken');

let logger = require('arrowjs').logger;

module.exports = function (controller, component, app) {

    controller.login = function (req, res) {
        passport.authenticate('local', function (err, user, info) {
            if (err) {
                return res.status(500).json({error: err.message});
            }
            if (!user) {
                return res.status(403).json({error: info.message});
            }

            app.feature.users.actions.generateToken(user.id)
                .then(function (result) {
                    res.json(result);
                })
                .catch(function (err) {
                    logger.error(err);
                    res.status(500).json(err);
                })

        })(req, res);
    }

    controller.refreshToken = function (req, res) {
        let auth_header = req.headers.authorization;
        if (!auth_header)
            return res.sendStatus(401);
        let authScheme = app.getConfig('authScheme');
        if (!auth_header.startsWith(authScheme))
            return res.sendStatus(401);
        let accessToken = auth_header.replace(authScheme + ' ', '');
        try {
            var jwtPayload = jwt.verify(accessToken, app.getConfig('restApiKey'), {ignoreExpiration: true});

        } catch (err) {
            return res.status(401).json(err);
        }
        Promise.coroutine(function *() {
            let user_token = yield app.models.user_token.find({
                where: {
                    user_id: jwtPayload.id,
                    jwtId: jwtPayload.jti,
                    refresh_token: req.body.refreshToken,
                    refresh_token_expires: {
                        $gt: Date.now()
                    }
                }
            });
            if (!user_token)
                return res.status(401).json({
                    message: 'Token không hợp lệ hoặc đã hết hạn'
                });

            let result = yield app.feature.users.actions.generateToken(jwtPayload.id);
            res.json(result);

        })().catch(function (err) {
            logger.error(err);
            res.status(500).json(err);
        })

    }

    controller.register = function (req, res) {
        Promise.coroutine(function*() {
            let data = req.body;

            let user = yield app.models.user.find({
                where: {
                    user_email: data.email
                }
            });

            if (user) {
                return res.sendStatus(405);
            }

            let role = yield app.models.role.find({
                order: [['created_at', 'desc']]
            });

            user = yield app.models.user.create({
                user_email: data.email,
                display_name: data.email,
                user_pass: data.password,
                role_ids: [role.id]
            });

            let activeTokenBuffer = yield randomBytesAsync(20);
            let activeToken = activeTokenBuffer.toString('hex');

            yield app.models.user_token.create({
                user_id: user.id,
                active_token: activeToken
            });

            return res.api.render('mail_tpl/active_user', {
                user_email: user.user_email,
                user_id: user.id,
                status: 'new',
                token: activeToken
            }, function (err, emailHTML) {
                if (err) {
                    logger.error(err);
                } else {
                    // Send email
                    let mailOptions = {
                        from: app.getConfig('mailer_from'), // sender address
                        to: user.user_email,
                        replyTo: app.getConfig('mailer_reply'),
                        subject: app.getConfig('app.title') + ': Xác nhận đăng ký tài khoản',
                        html: emailHTML
                    };
                    ArrowHelper.sendMail(app, mailOptions);
                    return res.sendStatus(200);
                }
            });
        })().catch(function (err) {
            return res.status(400).json({
                name: err.name,
                message: err.message
            });
        });
    }

    controller.activeUser = function (req, res) {
        Promise.coroutine(function*() {
            let data = req.body;

            let user = yield app.models.user.find({
                where: {
                    user_email: data.email,
                    user_status: false
                }
            });

            if (!user) {
                return res.sendStatus(404);
            }

            let activeTokenBuffer = yield randomBytesAsync(20);
            let activeToken = activeTokenBuffer.toString('hex');

            let user_token = yield app.models.user_token.find({
                where: {
                    user_id: user.id
                }
            });

            if (!user_token) {
                user_token = yield app.models.user_token.create({
                    user_id: user.id,
                    active_token: activeToken
                });
            }

            return res.api.render('mail_tpl/active_user', {
                user_email: user.user_email,
                user_id: user.id,
                status: 'active',
                token: user_token.active_token
            }, function (err, emailHTML) {
                if (err) {
                    logger.error(err);
                } else {
                    // Send email
                    let mailOptions = {
                        from: app.getConfig('mailer_from'), // sender address
                        to: user.user_email,
                        replyTo: app.getConfig('mailer_reply'),
                        subject: app.getConfig('app.title') + ': Xác nhận kích hoạt tài khoản',
                        html: emailHTML
                    };
                    ArrowHelper.sendMail(app, mailOptions);
                    return res.sendStatus(200);
                }
            });
        })().catch(function (err) {
            return res.status(400).json({
                name: err.name,
                message: err.message
            });
        });
    }

};