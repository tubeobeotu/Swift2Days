'use strict';

module.exports = function (component) {
    let controller = component.controllers.frontend;

    return {

        "/api/login": {
            post: {
                handler: controller.login
            }
        },

        "/api/refresh-token": {
            post: {
                handler: controller.refreshToken
            }
        },

        "/api/image-list": {
            get: {
                handler: controller.imageList,
                authenticate: true
            }
        },

        "/api/create-image": {
            post: {
                handler: controller.createImage,
                authenticate: true
            }
        }

    }
};