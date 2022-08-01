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
export function getDynamicLink(): Promise<DynamicLinkPayload | null>;
/**
 *
 * Registers callback that is triggered on each dynamic link click.
 * @param {(payload: DynamicLinkPayload) => void} callback Callback function
 * @param {(error: string) => void} errorCallback Error callback function
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.onDynamicLink(function(payload) {
 *     console.log("Dynamic link click with data:", payload);
 * });
 */
export function onDynamicLink(callback: (payload: DynamicLinkPayload) => void, errorCallback: (error: string) => void): void;
/**
 *
 * Creates a Dynamic Link from the parameters.
 * @param {DynamicLinkOptions} params Parameters to use for building a link
 * @returns {Promise<string>} Fulfils promise with created link string
 *
 * @example
 * cordova.plugins.firebase.dynamiclinks.createDynamicLink({
 *     link: "https://google.com"
 * });
 */
export function createDynamicLink(params: DynamicLinkOptions): Promise<string>;
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
 * });
 */
export function createShortDynamicLink(params: DynamicLinkOptions): Promise<string>;
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
 * cordova.plugins.firebase.dynamiclinks.createShortDynamicLink({
 *     link: "https://google.com"
 * });
 */
export function createUnguessableDynamicLink(params: DynamicLinkOptions): Promise<string>;
export type DynamicLinkPayload = {
    /**
     * Link parameter of the dynamic link.
     */
    deepLink: string | null;
    /**
     * The time that the user clicked on the dynamic link.
     */
    clickTimestamp: number;
    /**
     * The minimum app version requested to process the dynamic link that can be compared directly with versionCode (Android only)
     */
    minimumAppVersion?: number;
};
export type DynamicLinkAndroidInfo = {
    /**
     * Package name of the Android app to use to open the link.
     */
    androidPackageName: string;
    /**
     * Link to open when the app isn't installed.
     */
    androidFallbackLink: string;
    /**
     * VersionCode of the minimum version of your app that can open the link.
     */
    androidMinPackageVersionCode: number;
};
export type DynamicLinkIosInfo = {
    /**
     * Bundle ID of the iOS app to use to open the link.
     */
    iosBundleId: string;
    /**
     * Link to open when the app isn't installed.
     */
    iosFallbackLink: string;
    /**
     * Link to open on iPads when the app isn't installed.
     */
    iosIpadFallbackLink: string;
    /**
     * Bundle ID of the iOS app to use on iPads to open the link.
     */
    iosIpadBundleId: string;
    /**
     * App Store ID, used to send users to the App Store when the app isn't installed.
     */
    iosAppStoreId: string;
};
export type DynamicLinkNavigationInfo = {
    /**
     * If true, app preview page will be disabled and there will be a redirect to the FDL.
     */
    enableForcedRedirect: boolean;
};
export type DynamicLinkGoogleAnalyticsInfo = {
    /**
     * Campaign source; used to identify a search engine, newsletter, or other source.
     */
    utmSource: string;
    /**
     * Campaign medium; used to identify a medium such as email or cost-per-click (cpc).
     */
    utmMedium: string;
    /**
     * Campaign name; The individual campaign name, slogan, promo code, etc. for a product.
     */
    utmCampaign: string;
    /**
     * Campaign content; used for A/B testing and content-targeted ads to differentiate ads or links that point to the same URL.
     */
    utmContent: string;
    /**
     * Campaign term; used with paid search to supply the keywords for ads.
     */
    utmTerm: string;
};
export type DynamicLinkItunesAnalyticsInfo = {
    /**
     * Affiliate token used to create affiliate-coded links.
     */
    at: string;
    /**
     * Campaign token that developers can add to any link in order to track sales from a specific marketing campaign.
     */
    ct: string;
    /**
     * Provider token that enables analytics for Dynamic Links from within iTunes Connect.
     */
    pt: string;
};
export type DynamicLinkSocialInfo = {
    /**
     * Title to use when the Dynamic Link is shared in a social post.
     */
    socialTitle: string;
    /**
     * Description to use when the Dynamic Link is shared in a social post.
     */
    socialDescription: string;
    /**
     * URL to an image related to this link.
     */
    socialImageLink: string;
};
/**
 * Options when creating a dynamic link Parameter names has the same meaning as
 * in the {@link https://firebase.google.com/docs/reference/dynamic-links/link-shortener#parameters | Firebase Dynamic Links Short Links API Reference}
 */
export type DynamicLinkOptions = {
    /**
     * The link your app will open.
     */
    link: string;
    /**
     * Domain uri prefix to use for this Dynamic Link.
     */
    domainUriPrefix?: string;
    /**
     * Android parameters.
     */
    androidInfo?: DynamicLinkAndroidInfo;
    /**
     * iOS parameters.
     */
    iosInfo?: DynamicLinkIosInfo;
    /**
     * Navigation info parameters.
     */
    navigationInfo?: DynamicLinkNavigationInfo;
    /**
     * Google Analytics parameters.
     */
    googlePlayAnalytics?: DynamicLinkGoogleAnalyticsInfo;
    /**
     * iTunes Connect App Analytics parameters.
     */
    itunesConnectAnalytics?: DynamicLinkItunesAnalyticsInfo;
    /**
     * Social meta-tag parameters.
     */
    socialMetaTagInfo?: DynamicLinkSocialInfo;
};
