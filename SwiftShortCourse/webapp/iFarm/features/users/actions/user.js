'use strict';

let Promise = require('arrowjs').Promise;
let randomBytesAsync = Promise.promisify(require('crypto').randomBytes);
let crypto = require('crypto');
let jwt = require('jsonwebtoken');
let _ = require('arrowjs')._;

module.exports = function (action, comp, app) {

    /**
     * Find user by ID
     * @param id {integer} - Id of user
     */
    action.findById = function (id) {
        return app.models.user.findById(id);
    };

    /**
     * Find user by email
     * @param email {string} - Email of user
     */
    action.findByEmail = function (email) {
        return app.models.user.find({
            where: {
                user_email: email.toLowerCase()
            }
        });
    };

    /**
     * Find user with conditions
     * @param conditions {object} - Conditions used in query
     */
    action.find = function (conditions) {
        return app.models.user.find(conditions);
    };

    /**
     * Find user with conditions, include roles
     * @param conditions {object} - Conditions used in query
     */
    action.findWithRole = function (conditions) {
        return Promise.coroutine(function*() {
            let user = yield app.models.user.find(conditions);
            let permissions = {
                feature: {},
                plugin: {}
            };
            if (!user)
                return null;
            yield Promise.map(user.role_ids, function (role_id) {
                return app.models.role.findById(role_id).then(function (role) {
                    let role_permissions = JSON.parse(role.permissions);
                    if (role_permissions.feature) {
                        Object.keys(role_permissions.feature).forEach(function (key) {
                            permissions.feature[key] = _.union(permissions.feature[key], role_permissions.feature[key]);
                        });
                    }
                    if (role_permissions.plugin) {
                        Object.keys(role_permissions.plugin).forEach(function (key) {
                            permissions.plugin[key] = _.union(permissions.plugin[key], role_permissions.plugin[key]);
                        });
                    }
                });
            });

            user = user.toJSON();
            user.role = {
                permissions: JSON.stringify(permissions)
            };
            return user;
        })();
    };

    /**
     * Find all users with conditions
     * @param conditions {object} - Conditions used in query
     */
    action.findAll = function (conditions) {
        return app.models.user.findAll(conditions);
    };

    /**
     * Find and count all users with conditions
     * @param conditions {object} - Conditions used in query
     */
    action.findAndCountAll = function (conditions) {
        return app.models.user.findAndCountAll(conditions);
    };

    /**
     * Count users
     */
    action.count = function () {
        return app.models.user.count()
    };

    /**
     * Create new user
     * @param data {object} - Data of new user
     */
    action.create = function (data) {
        data = optimizeData(data);
        return app.models.user.create(data);
    };

    /**
     * Update user
     * @param user {object} - User need to update
     * @param data {object} - New data
     */
    action.update = function (user, data) {
        data = optimizeData(data);
        return app.models.user.update(data, {
            where: {
                id: user.id
            }
        }).then(function () {
            return app.feature.users.actions.findWithRole({
                where: {
                    id: user.id
                }
            });
        })
    };

    /**
     * Delete users by ids
     * @param ids {array} - Array ids of users
     */
    action.destroy = function (ids) {
        return app.models.user.destroy({
            where: {
                id: {
                    $in: ids
                }
            }
        })
    };

    function optimizeData(data) {
        // Trim display name
        if (data.display_name) data.display_name = data.display_name.trim();

        return data;
    }

    action.generateToken = function (userId) {
        return Promise.coroutine(function*() {
            let refreshTokenBuffer = yield randomBytesAsync(20);
            let refreshToken = refreshTokenBuffer.toString('hex');
            let now = Date.now();

            let userToken = yield app.models.user_token.find({
                where: {
                    user_id: userId
                }
            });
            if (!userToken) {
                userToken = yield app.models.user_token.create({
                    user_id: userId
                });
            }

            let jwtId = crypto.pbkdf2Sync(now.toString(), app.getConfig('restApiKey'), 10000, 64, "sha1").toString('base64');
            yield userToken.update({
                jwtId: jwtId,
                refresh_token: refreshToken,
                refresh_token_expires: now + Number(app.getConfig('refreshTokenExpireTime'))
            });

            let expiredTime = Math.floor((now + Number(app.getConfig('accessTokenExpireTime'))) / 1000);

            var accessToken = jwt.sign({id: userId, exp: expiredTime}, app.getConfig('restApiKey'), {jwtid: jwtId});
            return {
                accessToken: accessToken,
                expiredTime: expiredTime,
                authScheme: app.getConfig('authScheme'),
                refreshToken: refreshToken
            };
        })();
    }

};