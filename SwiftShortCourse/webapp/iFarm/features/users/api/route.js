'use strict';

module.exports = function (component, app) {

    let controller = component.controllers.api;

    return {
        "/users": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: "index"
            }
        },
        "/users/page/:page([0-9]+)": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: "index"
            }
        },
        "/users/:sort/(:order)?": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: "index"
            }
        },
        "/users/page/:page([0-9]+)/:sort/(:order)?": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: "index"
            }
        },
        "/user/create": {
            post: {
                handler: controller.create,
                authenticate: true,
                permissions: "create"
            }
        },
        "/user": {
            get: {
                handler: controller.viewUser,
                authenticate: true
            },
            post: {
                handler: controller.updateUser,
                authenticate: true
            }
        },
        "/user/:uid([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})": {
            get: {
                handler: controller.view,
                authenticate: true,
                permissions: "index"
            },
            post: {
                handler: controller.update,
                authenticate: true,
                permissions: "update"
            },
            param: {
                key: "uid",
                handler: controller.userById
            }
        },
        "/user/change-pass": {
            post: {
                handler: controller.updatePass,
                authenticate: true
            }
        },
        "/user/change-email": {
            post: {
                handler: controller.updateEmail,
                authenticate: true
            }
        },
        "/user/forgot-password":{
            post: {
                handler: controller.retrievePass
            }
        }

    }
};

