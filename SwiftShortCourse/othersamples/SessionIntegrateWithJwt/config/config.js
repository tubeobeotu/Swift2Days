'use strict';

module.exports = {
    app: {
        title: 'ArrowJS CMS',
        description: '',
        keywords: '',
        logo: '',
        icon: ''
    },
    langPath: '/lang',
    language: 'en_US',
    uploadPath: '/fileman/uploads',
    long_stack: false,
    port: process.env.PORT || 8000,
    admin_prefix: 'admin',
    ArrowHelper: '/library/js_utilities/',
    restApiKey: 'a corgi dog',
    accessTokenExpireTime: 30 * 24 * 60 * 60 * 1000, // 1 month
    authScheme: 'JWT'
};