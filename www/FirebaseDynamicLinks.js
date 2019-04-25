var exec = require("cordova/exec");
var PLUGIN_NAME = "FirebaseDynamicLinks";

module.exports = {
    onDynamicLink: function(onSuccess, onError) {
        exec(onSuccess, onError, PLUGIN_NAME, "onDynamicLink", []);
    },
    createDynamicLink: function(params) {
        return new Promise(function(resolve, reject) {
            exec(resolve, reject, PLUGIN_NAME, "createDynamicLink", [params, 0]);
        });
    },
    createShortDynamicLink: function(params) {
        return new Promise(function(resolve, reject) {
            exec(resolve, reject, PLUGIN_NAME, "createDynamicLink", [params, 2]);
        });
    },
    createUnguessableDynamicLink: function(params) {
        return new Promise(function(resolve, reject) {
            exec(resolve, reject, PLUGIN_NAME, "createDynamicLink", [params, 1]);
        });
    }
};
