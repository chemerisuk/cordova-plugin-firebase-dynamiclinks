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

<!-- MarkdownTOC levels="2" autolink="true" -->

- [Supported Platforms](#supported-platforms)
- [Installation](#installation)
- [Type Aliases](#type-aliases)
- [Functions](#functions)

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

### DynamicLinkOptions

 **DynamicLinkOptions**: `Object`

Options when creating a dynamic link Parameter names has the same meaning as
in the Firebase Dynamic Links Short Links API Reference.

#### Type declaration

| Name | Type | Description |
| :------ | :------ | :------ |
| `androidInfo?` | { `androidFallbackLink`: `string` ; `androidMinPackageVersionCode`: `number` ; `androidPackageName`: `string`  } | Android parameters. |
| `androidInfo.androidFallbackLink` | `string` | - |
| `androidInfo.androidMinPackageVersionCode` | `number` | - |
| `androidInfo.androidPackageName` | `string` | - |
| `domainUriPrefix?` | `string` | Domain uri prefix to use for this Dynamic Link. |
| `googlePlayAnalytics?` | { `utmCampaign`: `string` ; `utmContent`: `string` ; `utmMedium`: `string` ; `utmSource`: `string` ; `utmTerm`: `string`  } | Google Analytics parameters. |
| `googlePlayAnalytics.utmCampaign` | `string` | - |
| `googlePlayAnalytics.utmContent` | `string` | - |
| `googlePlayAnalytics.utmMedium` | `string` | - |
| `googlePlayAnalytics.utmSource` | `string` | - |
| `googlePlayAnalytics.utmTerm` | `string` | - |
| `iosInfo?` | { `iosAppStoreId`: `string` ; `iosBundleId`: `string` ; `iosFallbackLink`: `string` ; `iosIpadBundleId`: `string` ; `iosIpadFallbackLink`: `string`  } | iOS parameters. |
| `iosInfo.iosAppStoreId` | `string` | - |
| `iosInfo.iosBundleId` | `string` | - |
| `iosInfo.iosFallbackLink` | `string` | - |
| `iosInfo.iosIpadBundleId` | `string` | - |
| `iosInfo.iosIpadFallbackLink` | `string` | - |
| `itunesConnectAnalytics?` | { `at`: `string` ; `ct`: `string` ; `pt`: `string`  } | iTunes Connect App Analytics parameters. |
| `itunesConnectAnalytics.at` | `string` | - |
| `itunesConnectAnalytics.ct` | `string` | - |
| `itunesConnectAnalytics.pt` | `string` | - |
| `link` | `string` | The link your app will open. |
| `navigationInfo?` | { `enableForcedRedirect`: `boolean`  } | Navigation info parameters. |
| `navigationInfo.enableForcedRedirect` | `boolean` | - |
| `socialMetaTagInfo?` | { `socialDescription`: `string` ; `socialImageLink`: `string` ; `socialTitle`: `string`  } | Social meta-tag parameters. |
| `socialMetaTagInfo.socialDescription` | `string` | - |
| `socialMetaTagInfo.socialImageLink` | `string` | - |
| `socialMetaTagInfo.socialTitle` | `string` | - |

### DynamicLinkPayload

 **DynamicLinkPayload**: `Object`

#### Type declaration

| Name | Type | Description |
| :------ | :------ | :------ |
| `clickTimestamp` | `number` | The time that the user clicked on the dynamic link. |
| `deepLink` | `string` \| ``null`` | Link parameter of the dynamic link. |
| `minimumAppVersion?` | `number` | The minimum app version requested to process the dynamic link that can be compared directly with versionCode (Android only) |

## Functions

### **createDynamicLink**(`params`): `Promise`<`string`\>

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
| `params` | [`DynamicLinkOptions`](FirebaseDynamicLinks.md#dynamiclinkoptions) | Parameters to use for building a link |

#### Returns

`Promise`<`string`\>

Fulfils promise with created link value

### **createShortDynamicLink**(`params`): `Promise`<`string`\>

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
| `params` | [`DynamicLinkOptions`](FirebaseDynamicLinks.md#dynamiclinkoptions) | Parameters to use for building a link |

#### Returns

`Promise`<`string`\>

Fulfils promise with created link value

### **createUnguessableDynamicLink**(`params`): `Promise`<`string`\>

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
| `params` | [`DynamicLinkOptions`](FirebaseDynamicLinks.md#dynamiclinkoptions) | Parameters to use for building a link |

#### Returns

`Promise`<`string`\>

Fulfils promise with created link value

### **getDynamicLink**(): `Promise`<[`DynamicLinkPayload`](FirebaseDynamicLinks.md#dynamiclinkpayload) \| ``null``\>

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

`Promise`<[`DynamicLinkPayload`](FirebaseDynamicLinks.md#dynamiclinkpayload) \| ``null``\>

Dynamic link payload.

### **onDynamicLink**(`callback`, `errorCallback`): `void`

Registers callback that is triggered on each dynamic link click.

**`Example`**

```ts
cordova.plugins.firebase.dynamiclinks.onDynamicLink(function(data) {
    console.log("Dynamic link click with data:", data);
});
```

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `callback` | (`payload`: [`DynamicLinkPayload`](FirebaseDynamicLinks.md#dynamiclinkpayload)) => `void` | Callback function |
| `errorCallback` | (`error`: `string`) => `void` | Error callback function |

#### Returns

`void`
