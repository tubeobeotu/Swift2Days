'use strict';

module.exports = {
    app: {
        title: 'iFarm',
        description: '',
        keywords: '',
        logo: '',
        icon: ''
    },
    domain: 'http://localhost:8000',
    langPath: '/lang',
    language: 'en_US',
    uploadPath: '/fileman/uploads',
    long_stack: false,
    port: process.env.PORT || 8000,
    admin_prefix: 'admin',
    ArrowHelper: '/library/js_utilities/',
    restApiKey: 'a corgi dog',
    accessTokenExpireTime: 30 * 60 * 1000, // 30 mins
    refreshTokenExpireTime: 60 * 60 * 1000, // 60 mins
    authScheme: 'JWT',
    socket_port: 2702
};
