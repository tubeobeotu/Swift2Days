/**
 * Created by chotoxautinh on 9/6/16.
 */
'use strict';

module.exports = function (sequelize, DataTypes) {
    return sequelize.define('user_token', {
        id: {
            type: DataTypes.UUID,
            defaultValue: DataTypes.UUIDV4,
            primaryKey: true
        },
        user_id: {
            type: DataTypes.UUID
        },
        jwtId: {
            type: DataTypes.STRING
        },
        reset_password_expires: {
            type: DataTypes.BIGINT
        },
        reset_password_token: {
            type: DataTypes.STRING
        },
        change_email: {
            type: DataTypes.STRING,
            validate: {
                isEmail: {
                    msg: 'Invalid email address'
                }
            }
        },
        change_email_expires: {
            type: DataTypes.BIGINT
        },
        change_email_token: {
            type: DataTypes.STRING
        },
        refresh_token: {
            type: DataTypes.STRING
        },
        refresh_token_expires: {
            type: DataTypes.BIGINT
        },
        active_token: {
            type: DataTypes.STRING
        }
    }, {
        timestamps: false,
        tableName: 'user_token',
    });
};
