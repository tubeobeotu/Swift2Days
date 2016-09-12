'use strict';

module.exports = function (sequelize, DataTypes) {

    return sequelize.define("image", {
        id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        name: {
            type: DataTypes.STRING,
            validate: {
                len: {
                    args: [1, 255],
                    msg: 'Title cannot empty or too long'
                }
            }
        },
        photofile: {
            type: DataTypes.STRING
        }
    }, {
        tableName: 'arr_image',
        timestamps: false
    });

};