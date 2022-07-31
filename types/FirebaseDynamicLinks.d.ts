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
export function getDynamicLink(): Promise<DynamicLinkPayload | null>;
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
export function onDynamicLink(callback: (payload: DynamicLinkPayload) => void, errorCallback: (error: string) => void): void;
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
export function createDynamicLink(params: DynamicLinkOptions): Promise<string>;
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
export function createShortDynamicLink(params: DynamicLinkOptions): Promise<string>;
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
/**
 *
 * Options when creating a dynamic link Parameter names has the same meaning as
 * in the Firebase Dynamic Links Short Links API Reference.
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
    androidInfo?: {
        androidPackageName: string;
        androidFallbackLink: string;
        androidMinPackageVersionCode: number;
    };
    /**
     * iOS parameters.
     */
    iosInfo?: {
        iosBundleId: string;
        iosFallbackLink: string;
        iosIpadFallbackLink: string;
        iosIpadBundleId: string;
        iosAppStoreId: string;
    };
    /**
     * Navigation info parameters.
     */
    navigationInfo?: {
        enableForcedRedirect: boolean;
    };
    /**
     * Google Analytics parameters.
     */
    googlePlayAnalytics?: {
        utmSource: string;
        utmMedium: string;
        utmCampaign: string;
        utmContent: string;
        utmTerm: string;
    };
    /**
     * iTunes Connect App Analytics parameters.
     */
    itunesConnectAnalytics?: {
        at: string;
        ct: string;
        pt: string;
    };
    /**
     * Social meta-tag parameters.
     */
    socialMetaTagInfo?: {
        socialTitle: string;
        socialDescription: string;
        socialImageLink: string;
    };
};
