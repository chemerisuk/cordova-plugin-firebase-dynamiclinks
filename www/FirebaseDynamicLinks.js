var PLUGIN_NAME = "FirebaseDynamicLinks";
// @ts-ignore
var exec = require("cordova/exec");

exports.getDynamicLink =
/**
 *
 * Determines if the app has a pending dynamic link and provide access to the dynamic link parameters.
 * @returns {Promise<DynamicLinkPayload|null>} Fulfils promise with dynamic link payload when it exists.
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
 * @param {(error: string) => void} [errorCallback] Error callback function
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.onDynamicLink(function(payload) {
 *     console.log("Dynamic link click with data:", payload);
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
 * @returns {Promise<string>} Fulfils promise with created link string
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.createDynamicLink({
 *     link: "https://google.com"
 * }).then(function(deepLink) {
 *     console.log("Generated deep link", deepLink);
 * });
 */
function(params) {
    return new Promise(function(resolve, reject) {
        exec(resolve, reject, PLUGIN_NAME, "createDynamicLink", [params, 0]);
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
 * @returns {Promise<string>} Fulfils promise with created link string
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.createShortDynamicLink({
 *     link: "https://google.com"
 * }).then(function(deepLink) {
 *     console.log("Generated deep link", deepLink);
 * });
 */
function(params) {
    return new Promise(function(resolve, reject) {
        exec(resolve, reject, PLUGIN_NAME, "createDynamicLink", [
            params,
            // @ts-ignore
            cordova.platformId === "ios" ? 1 : 2
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
 * @returns {Promise<string>} Fulfils promise with created link string
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.createUnguessableDynamicLink({
 *     link: "https://google.com"
 * }).then(function(deepLink) {
 *     console.log("Generated deep link", deepLink);
 * });
 */
function(params) {
    return new Promise(function(resolve, reject) {
        exec(resolve, reject, PLUGIN_NAME, "createDynamicLink", [
            params,
            // @ts-ignore
            cordova.platformId === "ios" ? 2 : 1
        ]);
    });
};

/**
 *
 * @typedef DynamicLinkPayload
 * @property {string|null} deepLink Link parameter of the dynamic link.
 * @property {number} clickTimestamp The time that the user clicked on the dynamic link.
 * @property {number} [minimumAppVersion] The minimum app version requested to process the dynamic link that can be compared directly with versionCode (Android only)
 */

/**
 *
 * @typedef DynamicLinkAndroidInfo
 * @property {string} androidPackageName Package name of the Android app to use to open the link.
 * @property {string} androidFallbackLink Link to open when the app isn't installed.
 * @property {number} androidMinPackageVersionCode VersionCode of the minimum version of your app that can open the link.
 */

/**
 *
 * @typedef DynamicLinkIosInfo
 * @property {string} iosBundleId Bundle ID of the iOS app to use to open the link.
 * @property {string} iosFallbackLink Link to open when the app isn't installed.
 * @property {string} iosIpadFallbackLink Link to open on iPads when the app isn't installed.
 * @property {string} iosIpadBundleId Bundle ID of the iOS app to use on iPads to open the link.
 * @property {string} iosAppStoreId App Store ID, used to send users to the App Store when the app isn't installed.
 */

/**
 *
 * @typedef DynamicLinkNavigationInfo
 * @property {boolean} enableForcedRedirect If true, app preview page will be disabled and there will be a redirect to the FDL.
 */

/**
 *
 * @typedef DynamicLinkGoogleAnalyticsInfo
 * @property {string} utmSource Campaign source; used to identify a search engine, newsletter, or other source.
 * @property {string} utmMedium Campaign medium; used to identify a medium such as email or cost-per-click (cpc).
 * @property {string} utmCampaign Campaign name; The individual campaign name, slogan, promo code, etc. for a product.
 * @property {string} utmContent Campaign content; used for A/B testing and content-targeted ads to differentiate ads or links that point to the same URL.
 * @property {string} utmTerm Campaign term; used with paid search to supply the keywords for ads.
 */

/**
 *
 * @typedef DynamicLinkItunesAnalyticsInfo
 * @property {string} at Affiliate token used to create affiliate-coded links.
 * @property {string} ct Campaign token that developers can add to any link in order to track sales from a specific marketing campaign.
 * @property {string} pt Provider token that enables analytics for Dynamic Links from within iTunes Connect.
 */

/**
 *
 * @typedef DynamicLinkSocialInfo
 * @property {string} socialTitle Title to use when the Dynamic Link is shared in a social post.
 * @property {string} socialDescription Description to use when the Dynamic Link is shared in a social post.
 * @property {string} socialImageLink URL to an image related to this link.
 */

/**
 *
 * Options when creating a dynamic link Parameter names has the same meaning as
 * in the {@link https://firebase.google.com/docs/reference/dynamic-links/link-shortener#parameters | Firebase Dynamic Links Short Links API Reference}
 *
 * @typedef DynamicLinkOptions
 * @property {string} link The link your app will open.
 * @property {string} [domainUriPrefix] Domain uri prefix to use for this Dynamic Link.
 *
 * @property {DynamicLinkAndroidInfo} [androidInfo] Android parameters.
 * @property {DynamicLinkIosInfo} [iosInfo] iOS parameters.
 * @property {DynamicLinkNavigationInfo} [navigationInfo] Navigation info parameters.
 * @property {DynamicLinkGoogleAnalyticsInfo} [googlePlayAnalytics] Google Analytics parameters.
 * @property {DynamicLinkItunesAnalyticsInfo} [itunesConnectAnalytics] iTunes Connect App Analytics parameters.
 * @property {DynamicLinkSocialInfo} [socialMetaTagInfo] Social meta-tag parameters.
 */
