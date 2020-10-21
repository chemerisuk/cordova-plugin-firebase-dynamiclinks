# Cordova plugin for [Firebase Dynamic Links](https://firebase.google.com/docs/dynamic-links/)

[![NPM version][npm-version]][npm-url] [![NPM downloads][npm-downloads]][npm-url] [![NPM total downloads][npm-total-downloads]][npm-url] [![PayPal donate](https://img.shields.io/badge/paypal-donate-ff69b4?logo=paypal)][donate-url] [![Twitter][twitter-follow]][twitter-url]

## Index

<!-- MarkdownTOC levels="2" autolink="true" -->

- [Supported Platforms](#supported-platforms)
- [Installation](#installation)
- [Quirks](#quirks)
- [Methods](#methods)
- [Dynamic link parameters](#dynamic-link-parameters)

<!-- /MarkdownTOC -->

## Supported Platforms

- iOS
- Android
 
## Installation

    $ cordova plugin add cordova-plugin-firebase-dynamiclinks --variable APP_DOMAIN_NAME="mydomain.page.link"

Use variable `APP_DOMAIN_NAME` to specify your Google generated `*.page.link` domain or other custom domain.

    $ cordova plugin add cordova-plugin-firebase-dynamiclinks --variable APP_DOMAIN_NAME="mydomain.com" --variable APP_DOMAIN_PATH="/app1"

Use variables `APP_DOMAIN_PATH` to speciy a specific domain path prefix when using a custom domain. This is useful if multiple apps share the same root level domain. If specified this path **must** begin with a `/`.

Use variables `IOS_FIREBASE_DYNAMICLINKS_VERSION` and `ANDROID_FIREBASE_DYNAMICLINKS_VERSION` to override dependency versions for Firebase SDKs.

## Quirks
On Android you have to add `AndroidLaunchMode` setting in order to prevent creating of multiple app activities:
```xml
<preference name="AndroidLaunchMode" value="singleTask" />
```

To get callback for new app installs on iOS your dynamic link MUST have an [app preview page](https://firebase.google.com/docs/dynamic-links/link-previews), which is by default.

## Methods

### getDynamicLink
Determines if the app has a pending dynamic link and provide access to the dynamic link parameters.
```js
cordova.plugins.firebase.dynamiclinks.getDynamicLink().then(function(data) {
    if (data) {
        console.log("Read dynamic link data on app start:", data);
    } else {
        console.log("App wasn't started from a dynamic link");
    }
});
``` 

### onDynamicLink(_callback_)
Registers callback that is triggered on each dynamic link click.
```js
cordova.plugins.firebase.dynamiclinks.onDynamicLink(function(data) {
    console.log("Dynamic link click with data:", data);
});
```
Every `create*` method accepts `dynamicLinkInfo` object as the first argument. Read section below to understand all supported [dynamic link parameters](#dynamic-link-parameters).

### createDynamicLink(_parameters_)
Creates a Dynamic Link from the parameters. Returns a promise fulfilled with the new dynamic link url.
```js
cordova.plugins.firebase.dynamiclinks.createDynamicLink({
    link: "https://google.com"
}).then(function(url) {
    console.log("Dynamic link was created:", url);
});
```

### createShortDynamicLink(_parameters_)
Creates a shortened Dynamic Link from the parameters. Shorten the path to a string that is only as long as needed to be unique, with a minimum length of 4 characters. Use this method if sensitive information would not be exposed if a short Dynamic Link URL were guessed.
```js
cordova.plugins.firebase.dynamiclinks.createShortDynamicLink({
    link: "https://google.com"
}).then(function(url) {
    console.log("Dynamic link was created:", url);
});
```

### createUnguessableDynamicLink(_parameters_)
Creates a Dynamic Link from the parameters. Shorten the path to an unguessable string. Such strings are created by base62-encoding randomly generated 96-bit numbers, and consist of 17 alphanumeric characters. Use unguessable strings to prevent your Dynamic Links from being crawled, which can potentially expose sensitive information.
```js
cordova.plugins.firebase.dynamiclinks.createUnguessableDynamicLink({
    link: "https://google.com"
}).then(function(url) {
    console.log("Dynamic link was created:", url);
});
```

## Dynamic link parameters
Any create method supports all options below to customize a returned dynamic link. Parameter names has the same meaning as in the [Firebase Dynamic Links Short Links API Reference](https://firebase.google.com/docs/reference/dynamic-links/link-shortener#parameters):
```json
{
  "domainUriPrefix": string,
  "link": string,
  "androidInfo": {
    "androidPackageName": string,
    "androidFallbackLink": string,
    "androidMinPackageVersionCode": number
  },
  "iosInfo": {
    "iosBundleId": string,
    "iosFallbackLink": string,
    "iosIpadFallbackLink": string,
    "iosIpadBundleId": string,
    "iosAppStoreId": string
  },
  "navigationInfo": {
    "enableForcedRedirect": boolean,
  },
  "analyticsInfo": {
    "googlePlayAnalytics": {
      "utmSource": string,
      "utmMedium": string,
      "utmCampaign": string,
      "utmTerm": string,
      "utmContent": string
    },
    "itunesConnectAnalytics": {
      "at": string,
      "ct": string,
      "pt": string
    }
  },
  "socialMetaTagInfo": {
    "socialTitle": string,
    "socialDescription": string,
    "socialImageLink": string
  }
}
```

[npm-url]: https://www.npmjs.com/package/cordova-plugin-firebase-dynamiclinks
[npm-version]: https://img.shields.io/npm/v/cordova-plugin-firebase-dynamiclinks.svg
[npm-downloads]: https://img.shields.io/npm/dm/cordova-plugin-firebase-dynamiclinks.svg
[npm-total-downloads]: https://img.shields.io/npm/dt/cordova-plugin-firebase-dynamiclinks.svg?label=total+downloads
[twitter-url]: https://twitter.com/chemerisuk
[twitter-follow]: https://img.shields.io/twitter/follow/chemerisuk.svg?style=social&label=Follow%20me
[donate-url]: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=USD4VHG7CF6FN&source=url
