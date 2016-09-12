'use strict';

module.exports = {
    mailer_config: {
        pool: true,
        host: 'smtp.gmail.com',
        port: 465,
        secure: true, // use SSL
        auth: {
            user: 'user@gmail.com',
            pass: 'pass'
        }
    },
    mailer_from: 'Techmaster support <test@techmaster.vn>',
    mailer_to: 'test@techmaster.vn',
    mailer_reply: 'test@techmaster.vn'
};