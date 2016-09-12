'use strict';

let crypto = require('crypto');

module.exports = function (sequelize, DataTypes) {
    return sequelize.define('userToken', {
        id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        userId: {
            type: DataTypes.INTEGER,
            allowNull: false
        },
        jwtId:{
            type: DataTypes.STRING
        },
        reset_password_expires: {
            type: DataTypes.BIGINT
        },
        reset_password_token: {
            type: DataTypes.STRING
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
        }
    }, {
        indexes: [
            {
                unique: true,
                fields: ['userId']
            }
        ],
        timestamps: false,
        tableName: 'userToken'
    });
};
