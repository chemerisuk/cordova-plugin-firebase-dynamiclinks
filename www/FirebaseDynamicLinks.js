var exec = require("cordova/exec");
var PLUGIN_NAME = "FirebaseDynamicLinks";

module.exports = {
    onDynamicLink: function(onSuccess, onError) {
        exec(onSuccess, onError, PLUGIN_NAME, "onDynamicLink", []);
    }
};
