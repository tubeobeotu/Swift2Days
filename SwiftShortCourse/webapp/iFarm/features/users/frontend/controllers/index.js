/**
 * Created by chotoxautinh on 9/9/16.
 */
let Promise = require('arrowjs').Promise;
let randomBytesAsync = Promise.promisify(require('crypto').randomBytes);
let logger = require('arrowjs').logger;

module.exports = function (controller, component, app) {

    controller.activeUser = function (req, res) {
        app.models.user.find({
            where: {
                id: req.params.uid
            },
            include: [{
                model: app.models.user_token,
                where: {
                    active_token: req.params.token
                }
            }]
        }).then(function (user) {
            if (!user)
                return res.sendStatus(404);
            return Promise.all([
                user.update({
                    user_status: true
                }),
                user.user_token.update({
                    active_token: null
                })
            ]).then(function () {
                res.sendStatus(200);
            })
        });
    }

    controller.resetPassword = function (req, res) {
        Promise.coroutine(function *() {
            let user = yield app.models.user.find({
                where: {
                    id: req.params.uid
                },
                include: [{
                    model: app.models.user_token,
                    where: {
                        reset_password_token: req.params.token,
                        reset_password_expires: {
                            $gt: Date.now()
                        }
                    }
                }]
            });
            let newPassBuffer = yield randomBytesAsync(8);
            let newPass = newPassBuffer.toString('hex');

            if (!user)
                return res.sendStatus(404);
            yield Promise.all([
                user.update({
                    user_pass: user.hashPassword(newPass)
                }),
                user.user_token.update({
                    reset_password_token: null,
                    reset_password_expires: null
                })
            ]);

            res.frontend.render('mail_tpl/retrieve_password', {
                new_pass: newPass,
                user_email: user.user_email
            }, function (err, emailHTML) {
                if (err) {
                    logger.error(err);
                } else {
                    // Send email
                    let mailOptions = {
                        from: app.getConfig('mailer_from'), // sender address
                        to: user.user_email,
                        replyTo: app.getConfig('mailer_reply'),
                        subject: app.getConfig('app.title') + ': Xác nhận reset mật khẩu tài khoản',
                        html: emailHTML
                    };
                    ArrowHelper.sendMail(app, mailOptions);
                    return res.sendStatus(200);
                }
            })
        })();
    }

    controller.changeEmail = function (req, res) {
        Promise.coroutine(function *() {
            let user = yield app.models.user.find({
                where: {
                    id: req.params.uid
                },
                include: [{
                    model: app.models.user_token,
                    where: {
                        change_email_token: req.params.token,
                        change_email_expires: {
                            $gt: Date.now()
                        }
                    }
                }]
            });
            let old_email = user.user_email;

            if (!user)
                return res.sendStatus(404);
            yield Promise.all([
                user.update({
                    user_email: user.user_token.change_email
                }),
                user.user_token.update({
                    change_email_token: null,
                    change_email_expires: null,
                    change_email: null
                })
            ]);

            res.frontend.render('mail_tpl/change-email', {
                user_email: user.user_email
            }, function (err, emailHTML) {
                if (err) {
                    logger.error(err);
                } else {
                    // Send email
                    let mailOptions = {
                        from: app.getConfig('mailer_from'), // sender address
                        to: old_email + ', ' + user.user_email,
                        replyTo: app.getConfig('mailer_reply'),
                        subject: app.getConfig('app.title') + ': Xác nhận đổi email tài khoản',
                        html: emailHTML
                    };
                    ArrowHelper.sendMail(app, mailOptions);
                    return res.sendStatus(200);
                }
            })
        })();
    }

}