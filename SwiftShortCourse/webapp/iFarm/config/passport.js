'use strict';

let logger = require('arrowjs').logger;
let passport = require('passport');
let Promise = require('arrowjs').Promise;

module.exports = function (passport, app) {
    return {
        serializeUser: function (user, done) {
            done(null, user.id);
        },
        deserializeUser: function (id, done) {
            let redis = app.redisClient;
            let key = app.getConfig('redis_prefix') + 'current-user-' + id;

            Promise.coroutine(function*() {
                let result = yield redis.getAsync(key);

                if (result != null) {
                    let user;
                    try {
                        user = JSON.parse(result);
                    } catch (err) {
                        logger.error(err);
                        return done(null, false);
                    }

                    return done(null, user);
                }

                let user = yield app.feature.users.actions.findWithRole({
                    where: {
                        id: id,
                    }
                });

                // Set expires 300 seconds
                redis.setex(key, 300, JSON.stringify(user));
                done(null, user);
            })().catch(function (err) {
                logger.error(err);
                done(null, false);
            });
        },
        checkAuthenticate: function (req, res, next) {
            if (req.isAuthenticated()) {
                try {
                    req.session.permissions = res.locals.permissions = JSON.parse(req.user.role.permissions);
                } catch (err) {
                    req.session.permissions = null;
                }

                res.locals.user = req.user;
                return next();
            }
            if (req.originalUrl.startsWith('/admin')) {
                return res.redirect('/admin/login');
            }
            if (req.originalUrl.startsWith('/api')) {
                return passport.authenticate('jwt', function (err, user, info) {
                    if (err) {
                        return res.status(500).json({error: err.message});
                    }
                    if (!user) {
                        return res.status(401).json({error: info.message});
                    }

                    try {
                        req.session.permissions = JSON.parse(user.role.permissions);
                    } catch (err) {
                        req.session.permissions = null;
                    }
                    req.user = user;
                    next();

                })(req, res, next);
            }
            res.redirect('/');
        },
        handlePermission: function (req, res, next) {
            if (req.hasPermission) {
                res.locals.user = req.user;
                return next()
            }
            if (req.originalUrl.startsWith('/admin')) {
                req.flash.error('You do not have permission to access');
                return res.redirect('/admin/403');
            }
            return res.status(403).send('You do not have permission to access');
        },
        local_login: {
            strategy: 'local',
            option: {
                successRedirect: '/admin',
                failureRedirect: '/admin/login',
                failureFlash: true

            }
        }
    }
};