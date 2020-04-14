var exec = require("cordova/exec");
var PLUGIN_NAME = "FirebaseCrash";

module.exports = {
    log: function (message) {
        return new Promise(function (resolve, reject) {
            exec(resolve, reject, PLUGIN_NAME, "log", [message]);
        });
    },
    logError: function (message, stackTrace) {
        return new Promise(function (resolve, reject) {
            exec(resolve, reject, PLUGIN_NAME, "logError", [message, stackTrace]);
        });
    },
    setUserId: function (userId) {
        return new Promise(function (resolve, reject) {
            exec(resolve, reject, PLUGIN_NAME, "setUserId", [userId]);
        });
    },
    setEnabled: function (enabled) {
        return new Promise(function (resolve, reject) {
            exec(resolve, reject, PLUGIN_NAME, "setEnabled", [enabled]);
        });
    }
};
