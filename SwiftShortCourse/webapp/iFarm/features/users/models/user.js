'use strict';

let crypto = require('crypto');

module.exports = function (sequelize, DataTypes) {
    return sequelize.define('user', {
        id: {
            type: DataTypes.UUID,
            defaultValue: DataTypes.UUIDV4,
            primaryKey: true
        },
        user_pass: {
            type: DataTypes.STRING(255),
            allowNull: false,
            validate: {
                notEmpty: true
            }
        },
        user_email: {
            type: DataTypes.STRING,
            unique: true,
            allowNull: false,
            validate: {
                isEmail: {
                    msg: 'Invalid email address'
                }
            }
        },
        user_phone: {
            type: DataTypes.STRING
        },
        user_registered: {
            type: DataTypes.DATE,
            defaultValue: sequelize.fn('now')
        },
        display_name: {
            type: DataTypes.STRING(250),
            validate: {
                len: {
                    args: [1, 250],
                    msg: 'Display name cannot empty or exceed 250 characters'
                }
            }
        },
        user_image_url: {
            type: DataTypes.STRING(1000),
            defaultValue: '/img/noImage.png'
        },
        salt: DataTypes.STRING(255),
        user_status: {
            type: DataTypes.BOOLEAN,
            defaultValue: false
        },
        role_ids: {
            type: DataTypes.ARRAY(DataTypes.UUID),
            defaultValue: []
        }
    }, {
        timestamps: false,
        tableName: 'arr_user',
        instanceMethods: {
            authenticate: function (password) {
                return this.user_pass === this.hashPassword(password);
            },
            hashPassword: function (password) {
                if (this.salt && password) {
                    return crypto.pbkdf2Sync(password, this.salt, 10000, 64, 'sha256').toString('base64');
                } else {
                    return password;
                }
            }
        },
        hooks: {
            beforeCreate: function (user, op, fn) {
                user.salt = randomid(50);
                user.user_pass = user.hashPassword(user.user_pass);
                fn(null, user);
            }
        }
    });
};

let randomid = function (length) {
    let text = "";
    let possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (let i = 0; i < length; i++)
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
};