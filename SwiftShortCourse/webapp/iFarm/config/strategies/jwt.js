/**
 * Created by Cho To Xau Tinh on 29-Aug-16.
 */
'use strict';

/**
 * Module dependencies.
 */
let JwtStrategy = require('passport-jwt').Strategy;
let log = require('arrowjs').logger;


module.exports = function (passport, config, app) {

    var opts = {}
    opts.jwtFromRequest = function (req) {
        let auth_header = req.headers.authorization;
        if (!auth_header)
            return null;
        let authScheme = app.getConfig('authScheme');
        if (!auth_header.startsWith(authScheme))
            return null;
        return auth_header.replace(authScheme + ' ', '');
    }
    opts.secretOrKey = app.getConfig('restApiKey');
    opts.ignoreExpiration = false;

    // Use jwt strategy
    passport.use(new JwtStrategy(opts, function (jwt_payload, done) {
        app.feature.users.actions.findWithRole({
            where: {
                id: jwt_payload.id,
                user_status: true
            },
            include: [
                {
                    model: app.models.user_token,
                    where: {
                        jwtId: jwt_payload.jti
                    }
                }
            ]
        }).then(function (user) {
            if (!user) {
                ArrowHelper.createUserAdmin(app, function (result) {
                    if (!result) {
                        return done(null, false, {
                            message: 'Invalid Token ! Please login again.'
                        });
                    } else {
                        return done(null, false, {
                            message: 'Email default is \"admin@example.com\" <br> Password default is \"123456\" <br> Please login again!'
                        });
                    }
                })
            } else {
                return done(null, user);
            }
        }).catch(function (err) {
            log.error(err);
            return done(null, false, {
                message: 'Database error ! Please login again.'
            });
        });
    }));
};