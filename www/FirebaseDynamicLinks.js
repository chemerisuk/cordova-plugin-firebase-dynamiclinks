var PLUGIN_NAME = "FirebaseDynamicLinks";
// @ts-ignore
var exec = require("cordova/exec");

/**
 *
 *
 * @typedef DynamicLinkPayload
 * @property {string|null} deepLink Link parameter of the dynamic link.
 * @property {number} clickTimestamp The time that the user clicked on the dynamic link.
 * @property {number} [minimumAppVersion] The minimum app version requested to process the dynamic link that can be compared directly with versionCode (Android only)
 */

/**
 *
 * Options when creating a dynamic link Parameter names has the same meaning as
 * in the Firebase Dynamic Links Short Links API Reference.
 *
 * @see https://firebase.google.com/docs/reference/dynamic-links/link-shortener#parameters
 *
 * @typedef DynamicLinkOptions
 * @property {string} link The link your app will open.
 * @property {string} [domainUriPrefix] Domain uri prefix to use for this Dynamic Link.
 *
 * @property {object} [androidInfo] Android parameters.
 * @property {string} androidInfo.androidPackageName
 * @property {string} androidInfo.androidFallbackLink
 * @property {number} androidInfo.androidMinPackageVersionCode
 *
 * @property {object} [iosInfo] iOS parameters.
 * @property {string} iosInfo.iosBundleId
 * @property {string} iosInfo.iosFallbackLink
 * @property {string} iosInfo.iosIpadFallbackLink
 * @property {string} iosInfo.iosIpadBundleId
 * @property {string} iosInfo.iosAppStoreId
 *
 * @property {object} [navigationInfo] Navigation info parameters.
 * @property {boolean} navigationInfo.enableForcedRedirect
 *
 * @property {object} [googlePlayAnalytics] Google Analytics parameters.
 * @property {string} googlePlayAnalytics.utmSource
 * @property {string} googlePlayAnalytics.utmMedium
 * @property {string} googlePlayAnalytics.utmCampaign
 * @property {string} googlePlayAnalytics.utmContent
 * @property {string} googlePlayAnalytics.utmTerm
 *
 * @property {object} [itunesConnectAnalytics] iTunes Connect App Analytics parameters.
 * @property {string} itunesConnectAnalytics.at
 * @property {string} itunesConnectAnalytics.ct
 * @property {string} itunesConnectAnalytics.pt
 *
 * @property {object} [socialMetaTagInfo] Social meta-tag parameters.
 * @property {string} socialMetaTagInfo.socialTitle
 * @property {string} socialMetaTagInfo.socialDescription
 * @property {string} socialMetaTagInfo.socialImageLink
 */

exports.getDynamicLink =
/**
 *
 * Determines if the app has a pending dynamic link and provide access to the dynamic link parameters.
 * @returns {Promise<DynamicLinkPayload|null>} Dynamic link payload.
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.getDynamicLink().then(function(payload) {
 *     if (payload) {
 *         console.log("Read dynamic link data on app start:", payload);
 *     } else {
 *         console.log("App wasn't started from a dynamic link");
 *     }
 * });
 */
function() {
    return new Promise(function(resolve, reject) {
        exec(resolve, reject, PLUGIN_NAME, "getDynamicLink", []);
    });
};

exports.onDynamicLink =
/**
 *
 * Registers callback that is triggered on each dynamic link click.
 * @param {(payload: DynamicLinkPayload) => void} callback Callback function
 * @param {(error: string) => void} errorCallback Error callback function
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.onDynamicLink(function(data) {
 *     console.log("Dynamic link click with data:", data);
 * });
 */
function(callback, errorCallback) {
    exec(callback, errorCallback, PLUGIN_NAME, "onDynamicLink", []);
};

exports.createDynamicLink =
/**
 *
 * Creates a Dynamic Link from the parameters.
 * @param {DynamicLinkOptions} params Parameters to use for building a link
 * @returns {Promise<string>} Fulfils promise with created link value
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.createDynamicLink({
 *     link: "https://google.com"
 * });
 */
function(params) {
    return new Promise(function(resolve, reject) {
        exec(resolve, reject, PLUGIN_NAME, "createDynamicLink", [
            params, 0
        ]);
    });
};

exports.createShortDynamicLink =
/**
 *
 * Creates a shortened Dynamic Link from the parameters. Shorten the path
 * to a string that is only as long as needed to be unique, with a minimum
 * length of 4 characters. Use this method if sensitive information would
 * not be exposed if a short Dynamic Link URL were guessed.
 * @param {DynamicLinkOptions} params Parameters to use for building a link
 * @returns {Promise<string>} Fulfils promise with created link value
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.createShortDynamicLink({
 *     link: "https://google.com"
 * });
 */
function(params) {
    return new Promise(function(resolve, reject) {
        exec(resolve, reject, PLUGIN_NAME, "createDynamicLink", [
            // @ts-ignore
            params, cordova.platformId === "ios" ? 1 : 2
        ]);
    });
};

exports.createUnguessableDynamicLink =
/**
 *
 * Creates a Dynamic Link from the parameters. Shorten the path to
 * an unguessable string. Such strings are created by base62-encoding
 * randomly generated 96-bit numbers, and consist of 17 alphanumeric
 * characters. Use unguessable strings to prevent your Dynamic Links
 * from being crawled, which can potentially expose sensitive information.
 * @param {DynamicLinkOptions} params Parameters to use for building a link
 * @returns {Promise<string>} Fulfils promise with created link value
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.createShortDynamicLink({
 *     link: "https://google.com"
 * });
 */
function(params) {
    return new Promise(function(resolve, reject) {
        exec(resolve, reject, PLUGIN_NAME, "createDynamicLink", [
            // @ts-ignore
            params, cordova.platformId === "ios" ? 2 : 1
        ]);
    });
};
