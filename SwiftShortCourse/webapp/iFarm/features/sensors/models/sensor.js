/**
 * Created by chotoxautinh on 9/7/16.
 */
'use strict';

module.exports = function (sequelize, DataTypes) {
    return sequelize.define('sensor', {
        id: {
            type: DataTypes.STRING,
            unique: true,
            primaryKey: true
        },
        farmId: {
            type: DataTypes.UUID
        },
        description: {
            type: DataTypes.STRING,
        },
        longitude: { // kinh độ
            type: DataTypes.FLOAT
        },
        latitude: { // vĩ độ
            type: DataTypes.FLOAT
        },
        status: { // 0: Disable, 1: Alarm, 2: Offline, 3: Online
            type: DataTypes.INTEGER
        },
        createdAt: DataTypes.DATE,
        createdBy: DataTypes.UUID,
        modifiedAt: DataTypes.DATE
    }, {
        tableName: 'arr_sensor',
        createdAt: 'createdAt',
        updatedAt: 'modifiedAt'
    });
};