var exec = require("cordova/exec");
var PLUGIN_NAME = "FirebaseDynamicLinks";

module.exports = {
    onDynamicLink: function(onSuccess, onError) {
        exec(onSuccess, onError, PLUGIN_NAME, "onDynamicLink", []);
    },
    createLink: function(params) {
        return new Promise(function(resolve, reject) {
            exec(resolve, reject, PLUGIN_NAME, "createLink", [params, 0]);
        });
    },
    createShortLink: function(params) {
        return new Promise(function(resolve, reject) {
            exec(resolve, reject, PLUGIN_NAME, "createLink", [params, 2]);
        });
    },
    createUnguessableLink: function(params) {
        return new Promise(function(resolve, reject) {
            exec(resolve, reject, PLUGIN_NAME, "createLink", [params, 1]);
        });
    }
};
