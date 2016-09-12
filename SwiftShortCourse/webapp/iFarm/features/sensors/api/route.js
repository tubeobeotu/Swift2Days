'use strict';

module.exports = function (component, app) {

    let controller = component.controllers.api;
    let sensorPermission = ['manage_sensors', 'manage_all_sensors'];

    return {
        "/sensors/": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: sensorPermission
            }
        },
        "/sensors/page/:page([0-9]+)": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: sensorPermission
            }
        },
        "/sensors/:sort/(:order)?": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: sensorPermission
            }
        },
        "/sensors/page/:page([0-9]+)/:sort/(:order)?": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: sensorPermission
            }
        },
        "/sensor/:sensorId": {
            get: {
                handler: controller.view,
                authenticate: true,
                permissions: sensorPermission
            },
            post: {
                handler: controller.update,
                authenticate: true,
                permissions: sensorPermission
            },
            delete: {
                handler: controller.delete,
                authenticate: true,
                permissions: sensorPermission
            },
            param: {
                key: "sensorId",
                handler: controller.sensorRead
            }
        },

        "/record/create":{
            post: {
                handler: controller.receiveRecord
            }
        }

    }

};

