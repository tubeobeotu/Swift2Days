'use strict';

const Arrow = require('arrowjs');
const application = new Arrow();

application.start({
    passport: true,
    role: true
});

const express = require('express');
const serverSocket = require('http').Server(express);
const logger = require('arrowjs').logger;

var socket_port = application.getConfig('socket_port');

serverSocket.listen(socket_port, function () {
    require('./ArrowSocket')(serverSocket, application);
    logger.info(`Chat Server is running on port ${socket_port}`);
});