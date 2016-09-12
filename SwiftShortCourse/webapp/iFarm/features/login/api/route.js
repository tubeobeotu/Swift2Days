'use strict';

module.exports = function (component, app) {

    let controller = component.controllers.api;

    return {
        "/login": {
            post: {
                handler: controller.login
            }
        },

        "/refresh-token": {
            post: {
                handler: controller.refreshToken
            }
        },

        "/register": {
            post: {
                handler: controller.register
            }
        },

        "/request-active-user": {
            post: {
                handler: controller.activeUser
            }
        }
    }

};

