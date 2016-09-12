/**
 * Created by chotoxautinh on 9/7/16.
 */
'use strict';

module.exports = function (sequelize, DataTypes) {
    return sequelize.define('sensor_data', {
        id: {
            type: DataTypes.UUID,
            defaultValue: DataTypes.UUIDV4,
            primaryKey: true
        },
        sensorId: {
            type: DataTypes.STRING
        },
        temperature: { // nhiệt độ
            type: DataTypes.FLOAT,
        },
        moisture: { // độ ẩm
            type: DataTypes.FLOAT
        },
        pH: { // độ pH
            type: DataTypes.FLOAT
        },
        battery: { // trạng thái pin
            type: DataTypes.FLOAT
        },
        note: DataTypes.STRING,
        createdAt: DataTypes.DATE,
    }, {
        tableName: 'sensor_data',
        createdAt: 'createdAt',
        updatedAt: false
    });
};
