"use strict";

module.exports = {
    db: {
        host: 'localhost',
        port: '5432',
        database: 'arrowjs',
        username: 'postgres',
        password: '',
        dialect: 'postgres',
        logging: false
    },
    associate: function (models) {
        models.menu.hasMany(models.menu_detail, {foreignKey: 'menu_id'});
        models.menu_detail.belongsTo(models.menu, {foreignKey: 'menu_id'});
        models.post.belongsTo(models.user, {foreignKey: "created_by"});

        /* User */
        models.user.hasOne(models.user_token, {foreignKey: "user_id"}, { onDelete: 'cascade' });
        models.user_token.belongsTo(models.user, {foreignKey: "user_id"});

        /* Sensor */
        models.sensor.hasMany(models.sensor_data, {foreignKey: 'sensorId'}, { onDelete: null });
        models.sensor_data.belongsTo(models.sensor, {foreignKey: 'sensorId'});

        /* Farm */
        models.farm.hasMany(models.sensor, {foreignKey: 'farmId'}, { onDelete: 'cascade' });
        models.sensor.belongsTo(models.farm, {foreignKey: 'farmId'});
    }
};