# Cordova plugin for [Firebase Dynamic Links](https://firebase.google.com/docs/dynamic-links/)

[![NPM version][npm-version]][npm-url] [![NPM downloads][npm-downloads]][npm-url] [![NPM total downloads][npm-total-downloads]][npm-url] [![PayPal donate](https://img.shields.io/badge/paypal-donate-ff69b4?logo=paypal)][donate-url] [![Twitter][twitter-follow]][twitter-url]

[npm-url]: https://www.npmjs.com/package/cordova-plugin-firebase-dynamiclinks
[npm-version]: https://img.shields.io/npm/v/cordova-plugin-firebase-dynamiclinks.svg
[npm-downloads]: https://img.shields.io/npm/dm/cordova-plugin-firebase-dynamiclinks.svg
[npm-total-downloads]: https://img.shields.io/npm/dt/cordova-plugin-firebase-dynamiclinks.svg?label=total+downloads
[twitter-url]: https://twitter.com/chemerisuk
[twitter-follow]: https://img.shields.io/twitter/follow/chemerisuk.svg?style=social&label=Follow%20me
[donate-url]: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=USD4VHG7CF6FN&source=url

## Index

<!-- MarkdownTOC levels="2,3" autolink="true" -->

- [Supported Platforms](#supported-platforms)
- [Installation](#installation)
    - [Adding required configuration files](#adding-required-configuration-files)
- [Type Aliases](#type-aliases)
    - [DynamicLinkAndroidInfo](#dynamiclinkandroidinfo)
    - [DynamicLinkGoogleAnalyticsInfo](#dynamiclinkgoogleanalyticsinfo)
    - [DynamicLinkIosInfo](#dynamiclinkiosinfo)
    - [DynamicLinkItunesAnalyticsInfo](#dynamiclinkitunesanalyticsinfo)
    - [DynamicLinkNavigationInfo](#dynamiclinknavigationinfo)
    - [DynamicLinkOptions](#dynamiclinkoptions)
    - [DynamicLinkPayload](#dynamiclinkpayload)
    - [DynamicLinkSocialInfo](#dynamiclinksocialinfo)
- [Functions](#functions)
    - [createDynamicLink](#createdynamiclink)
    - [createShortDynamicLink](#createshortdynamiclink)
    - [createUnguessableDynamicLink](#createunguessabledynamiclink)
    - [getDynamicLink](#getdynamiclink)
    - [onDynamicLink](#ondynamiclink)

<!-- /MarkdownTOC -->

## Supported Platforms

- iOS
- Android

## Installation

    $ cordova plugin add cordova-plugin-firebase-dynamiclinks \
        --variable APP_DOMAIN_NAME="mydomain.page.link"

Use variable `APP_DOMAIN_NAME` to specify your Google generated `*.page.link` domain or other custom domain.

    $ cordova plugin add cordova-plugin-firebase-dynamiclinks \
        --variable APP_DOMAIN_NAME="mydomain.com" \
        --variable APP_DOMAIN_PATH="/app1"

Use variables `APP_DOMAIN_PATH` to speciy a specific domain path prefix when using a custom domain. This is useful if multiple apps share the same root level domain. If specified this path **must** begin with a `/`.

Use variables `IOS_FIREBASE_POD_VERSION` and `ANDROID_FIREBASE_BOM_VERSION` to override dependency versions for Firebase SDKs:

    $ cordova plugin add cordova-plugin-firebase-dynamiclinks \
    --variable IOS_FIREBASE_POD_VERSION="9.3.0" \
    --variable ANDROID_FIREBASE_BOM_VERSION="30.3.1"

### Adding required configuration files

Cordova supports `resource-file` tag for easy copying resources files. Firebase SDK requires `google-services.json` on Android and `GoogleService-Info.plist` on iOS platforms.

1. Put `google-services.json` and/or `GoogleService-Info.plist` into the root directory of your Cordova project
2. Add new tag for Android platform

```xml
<platform name="android">
    ...
    <resource-file src="google-services.json" target="app/google-services.json" />
</platform>
...
<platform name="ios">
    ...
    <resource-file src="GoogleService-Info.plist" />
</platform>
```

<!-- TypedocGenerated -->

## Type Aliases

### DynamicLinkAndroidInfo

 **DynamicLinkAndroidInfo**: `Object`

#### Type declaration

| Name | Type | Description |
| :------ | :------ | :------ |
| `androidFallbackLink` | `string` | Link to open when the app isn't installed. |
| `androidMinPackageVersionCode` | `number` | VersionCode of the minimum version of your app that can open the link. |
| `androidPackageName` | `string` | Package name of the Android app to use to open the link. |

___

### DynamicLinkGoogleAnalyticsInfo

 **DynamicLinkGoogleAnalyticsInfo**: `Object`

#### Type declaration

| Name | Type | Description |
| :------ | :------ | :------ |
| `utmCampaign` | `string` | Campaign name; The individual campaign name, slogan, promo code, etc. for a product. |
| `utmContent` | `string` | Campaign content; used for A/B testing and content-targeted ads to differentiate ads or links that point to the same URL. |
| `utmMedium` | `string` | Campaign medium; used to identify a medium such as email or cost-per-click (cpc). |
| `utmSource` | `string` | Campaign source; used to identify a search engine, newsletter, or other source. |
| `utmTerm` | `string` | Campaign term; used with paid search to supply the keywords for ads. |

___

### DynamicLinkIosInfo

 **DynamicLinkIosInfo**: `Object`

#### Type declaration

| Name | Type | Description |
| :------ | :------ | :------ |
| `iosAppStoreId` | `string` | App Store ID, used to send users to the App Store when the app isn't installed. |
| `iosBundleId` | `string` | Bundle ID of the iOS app to use to open the link. |
| `iosFallbackLink` | `string` | Link to open when the app isn't installed. |
| `iosIpadBundleId` | `string` | Bundle ID of the iOS app to use on iPads to open the link. |
| `iosIpadFallbackLink` | `string` | Link to open on iPads when the app isn't installed. |

___

### DynamicLinkItunesAnalyticsInfo

 **DynamicLinkItunesAnalyticsInfo**: `Object`

#### Type declaration

| Name | Type | Description |
| :------ | :------ | :------ |
| `at` | `string` | Affiliate token used to create affiliate-coded links. |
| `ct` | `string` | Campaign token that developers can add to any link in order to track sales from a specific marketing campaign. |
| `pt` | `string` | Provider token that enables analytics for Dynamic Links from within iTunes Connect. |

___

### DynamicLinkNavigationInfo

 **DynamicLinkNavigationInfo**: `Object`

#### Type declaration

| Name | Type | Description |
| :------ | :------ | :------ |
| `enableForcedRedirect` | `boolean` | If true, app preview page will be disabled and there will be a redirect to the FDL. |

___

### DynamicLinkOptions

 **DynamicLinkOptions**: `Object`

Options when creating a dynamic link Parameter names has the same meaning as
in the [Firebase Dynamic Links Short Links API Reference](https://firebase.google.com/docs/reference/dynamic-links/link-shortener#parameters)

#### Type declaration

| Name | Type | Description |
| :------ | :------ | :------ |
| `androidInfo?` | [`DynamicLinkAndroidInfo`](README.md#dynamiclinkandroidinfo) | Android parameters. |
| `domainUriPrefix?` | `string` | Domain uri prefix to use for this Dynamic Link. |
| `googlePlayAnalytics?` | [`DynamicLinkGoogleAnalyticsInfo`](README.md#dynamiclinkgoogleanalyticsinfo) | Google Analytics parameters. |
| `iosInfo?` | [`DynamicLinkIosInfo`](README.md#dynamiclinkiosinfo) | iOS parameters. |
| `itunesConnectAnalytics?` | [`DynamicLinkItunesAnalyticsInfo`](README.md#dynamiclinkitunesanalyticsinfo) | iTunes Connect App Analytics parameters. |
| `link` | `string` | The link your app will open. |
| `navigationInfo?` | [`DynamicLinkNavigationInfo`](README.md#dynamiclinknavigationinfo) | Navigation info parameters. |
| `socialMetaTagInfo?` | [`DynamicLinkSocialInfo`](README.md#dynamiclinksocialinfo) | Social meta-tag parameters. |

___

### DynamicLinkPayload

 **DynamicLinkPayload**: `Object`

#### Type declaration

| Name | Type | Description |
| :------ | :------ | :------ |
| `clickTimestamp` | `number` | The time that the user clicked on the dynamic link. |
| `deepLink` | `string` \| ``null`` | Link parameter of the dynamic link. |
| `minimumAppVersion?` | `number` | The minimum app version requested to process the dynamic link that can be compared directly with versionCode (Android only) |

___

### DynamicLinkSocialInfo

 **DynamicLinkSocialInfo**: `Object`

#### Type declaration

| Name | Type | Description |
| :------ | :------ | :------ |
| `socialDescription` | `string` | Description to use when the Dynamic Link is shared in a social post. |
| `socialImageLink` | `string` | URL to an image related to this link. |
| `socialTitle` | `string` | Title to use when the Dynamic Link is shared in a social post. |

## Functions

### createDynamicLink

**createDynamicLink**(`params`): `Promise`<`string`\>

Creates a Dynamic Link from the parameters.

**`Example`**

```ts
cordova.plugins.firebase.dynamiclinks.createDynamicLink({
    link: "https://google.com"
});
```

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `params` | [`DynamicLinkOptions`](README.md#dynamiclinkoptions) | Parameters to use for building a link |

#### Returns

`Promise`<`string`\>

Fulfils promise with created link string

___

### createShortDynamicLink

**createShortDynamicLink**(`params`): `Promise`<`string`\>

Creates a shortened Dynamic Link from the parameters. Shorten the path
to a string that is only as long as needed to be unique, with a minimum
length of 4 characters. Use this method if sensitive information would
not be exposed if a short Dynamic Link URL were guessed.

**`Example`**

```ts
cordova.plugins.firebase.dynamiclinks.createShortDynamicLink({
    link: "https://google.com"
});
```

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `params` | [`DynamicLinkOptions`](README.md#dynamiclinkoptions) | Parameters to use for building a link |

#### Returns

`Promise`<`string`\>

Fulfils promise with created link string

___

### createUnguessableDynamicLink

**createUnguessableDynamicLink**(`params`): `Promise`<`string`\>

Creates a Dynamic Link from the parameters. Shorten the path to
an unguessable string. Such strings are created by base62-encoding
randomly generated 96-bit numbers, and consist of 17 alphanumeric
characters. Use unguessable strings to prevent your Dynamic Links
from being crawled, which can potentially expose sensitive information.

**`Example`**

```ts
cordova.plugins.firebase.dynamiclinks.createShortDynamicLink({
    link: "https://google.com"
});
```

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `params` | [`DynamicLinkOptions`](README.md#dynamiclinkoptions) | Parameters to use for building a link |

#### Returns

`Promise`<`string`\>

Fulfils promise with created link string

___

### getDynamicLink

**getDynamicLink**(): `Promise`<[`DynamicLinkPayload`](README.md#dynamiclinkpayload) \| ``null``\>

Determines if the app has a pending dynamic link and provide access to the dynamic link parameters.

**`Example`**

```ts
cordova.plugins.firebase.dynamiclinks.getDynamicLink().then(function(payload) {
    if (payload) {
        console.log("Read dynamic link data on app start:", payload);
    } else {
        console.log("App wasn't started from a dynamic link");
    }
});
```

#### Returns

`Promise`<[`DynamicLinkPayload`](README.md#dynamiclinkpayload) \| ``null``\>

Fulfils promise with dynamic link payload when it exists.

___

### onDynamicLink

**onDynamicLink**(`callback`, `errorCallback`): `void`

Registers callback that is triggered on each dynamic link click.

**`Example`**

```ts
cordova.plugins.firebase.dynamiclinks.onDynamicLink(function(payload) {
    console.log("Dynamic link click with data:", payload);
});
```

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `callback` | (`payload`: [`DynamicLinkPayload`](README.md#dynamiclinkpayload)) => `void` | Callback function |
| `errorCallback` | (`error`: `string`) => `void` | Error callback function |

#### Returns

`void`
