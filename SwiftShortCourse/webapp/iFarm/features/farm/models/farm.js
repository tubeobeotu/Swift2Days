/**
 * Created by chotoxautinh on 9/7/16.
 */
'use strict';

module.exports = function (sequelize, DataTypes) {
    return sequelize.define('farm', {
        id: {
            type: DataTypes.UUID,
            defaultValue: DataTypes.UUIDV4,
            primaryKey: true
        },
        title: {
            type: DataTypes.STRING,
            allowNull: false
        },
        image: DataTypes.STRING,
        description: {
            type: DataTypes.STRING,
            allowNull: false
        },
        owner: {
            type: DataTypes.UUID,
            allowNull: false
        },
        createdAt: DataTypes.DATE
    }, {
        tableName: 'arr_farm',
        createdAt: 'createdAt',
        updatedAt: false
    });
};