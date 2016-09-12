'use strict';

module.exports = function (component, app) {

    let controller = component.controllers.api;
    let farmPermission = ['manage_farms', 'manage_all_farms'];

    return {
        "/farms": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: farmPermission
            }
        },
        "/farms/page/:page([0-9]+)": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: farmPermission
            }
        },
        "/farms/:sort/(:order)?": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: farmPermission
            }
        },
        "/farms/page/:page([0-9]+)/:sort/(:order)?": {
            get: {
                handler: controller.list,
                authenticate: true,
                permissions: farmPermission
            }
        },
        "/farm/create": {
            post: {
                handler: controller.create,
                authenticate: true,
                permissions: farmPermission
            }
        },
        "/farm/:farmId([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})": {
            get: {
                handler: controller.view,
                authenticate: true,
                permissions: farmPermission
            },
            post: {
                handler: controller.update,
                authenticate: true,
                permissions: farmPermission
            },
            delete: {
                handler: controller.delete,
                authenticate: true,
                permissions: farmPermission
            },
            param: {
                key: "farmId",
                handler: controller.farmRead
            }
        },

        "/farm/sensor": {
            post: {
                handler: controller.addSensor,
                authenticate: true,
                permissions: farmPermission
            }
        }
    }

};