/**
 * Created by chotoxautinh on 9/9/16.
 */
module.exports = function (component, app) {

    let controller = component.controllers.frontend;

    return {
        "/user/active/:uid([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/:token": {
            get: {
                handler: controller.activeUser
            },
        },
        "/user/reset-password/:uid([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/:token": {
            get: {
                handler: controller.resetPassword
            },
        },
        "/user/email/:uid([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/:token": {
            get: {
                handler: controller.changeEmail
            },
        }
    }
}