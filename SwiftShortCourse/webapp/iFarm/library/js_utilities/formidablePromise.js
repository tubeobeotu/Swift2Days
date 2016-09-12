/**
 * Created by chotoxautinh on 9/1/16.
 */
var
    Promise = require('arrowjs').Promise,
    formidable = require('formidable');

exports.parseRequest = function (req) {
    return new Promise(function (resolve, reject) {
        let form = new formidable.IncomingForm();
        form.parse(req, function (err, data, files) {
            if (err)
                return reject(err);
            return resolve([data, files]);
        });
    })
}