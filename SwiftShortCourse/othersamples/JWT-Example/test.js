/**
 * Created by phanducviet on 7/11/16.
 */
const
    url = 'http://192.168.1.99:8080/secured/ping',
    request = require('request'),
    jwt = require('jsonwebtoken'),
    payload = {
        user: 'paduvi',
        company: 'Techmaster'
    },
    secretKey = 'My Secret';

var token = jwt.sign(payload, secretKey, {algorithm: 'HS256', expiresIn: '1h'});

var callback = function (error, response, body) {
    if (error) {
        console.error(error);
    } else {
        console.log("Status Code: " + response.statusCode);
        console.log("Response Data: " + body);
    }
}

var options = {
    url: url,
    headers: {
        'Authorization': 'Bearer ' + token
    }
}

request(options, callback);
