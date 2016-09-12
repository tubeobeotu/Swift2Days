/**
 * Created by chotoxautinh on 9/7/16.
 */
'use strict';

exports.filterRequest = function (req, app) {

    let limit = app.getConfig('page_size') || 10;

    let page = req.params.page || 1;
    let offset = (page - 1) * limit;
    let customCondition = {
        offset: offset,
        limit: limit
    }

    if (req.params.sort) {
        let order = req.params.order || 'DESC';
        Object.assign(customCondition, {order: [[req.params.sort, order]]});
    }

    Object.keys(req.query).map(function (key) {
        if (!customCondition.hasOwnProperty("where")) {
            customCondition.where = {};
        }
        Object.assign(customCondition.where, filterPrefix(key, req.query[key]));
    });

    return customCondition;
}
;

let filterPrefix = function (key, value) {
    let filter = {};
    if (key.endsWith("_gt")) {
        let property = key.substring(0, key.lastIndexOf("_"));
        filter[property] = {
            $gt: value
        }
        return filter;
    }
    if (key.endsWith("_gte")) {
        let property = key.substring(0, key.lastIndexOf("_"));
        filter[property] = {
            $gte: value
        }
        return filter;
    }
    if (key.endsWith("_lt")) {
        let property = key.substring(0, key.lastIndexOf("_"));
        filter[property] = {
            $lt: value
        }
        return filter;
    }
    if (key.endsWith("_lte")) {
        let property = key.substring(0, key.lastIndexOf("_"));
        filter[property] = {
            $lte: value
        }
        return filter;
    }
    if (key.endsWith("_like")) {
        let property = key.substring(0, key.lastIndexOf("_"));
        filter[property] = {
            $like: value
        }
        return filter;
    }
    if (key.endsWith("_ilike")) {
        let property = key.substring(0, key.lastIndexOf("_"));
        filter[property] = {
            $ilike: value
        }
        return filter;
    }
    filter[key] = value;
    return filter;
}