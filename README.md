# cordova-plugin-firebase-dynamiclinks<br>[![NPM version][npm-version]][npm-url] [![NPM downloads][npm-downloads]][npm-url]
> Cordova plugin for [Firebase Dynamic Links](https://firebase.google.com/docs/dynamic-links/)
 
## Installation

    cordova plugin add cordova-plugin-firebase-dynamiclinks --save --variable APP_DOMAIN="example.com"

If you need to set a specific dependency version on Android then use variable `FIREBASE_VERSION`.

Variables `APP_DOMAIN` and `APP_PATH` specify web URL where your app will start an activity to handle the link.

## Supported Platforms

- iOS
- Android

Firebase Dynamic Links SDK has an [unresolved bug](https://github.com/firebase/firebase-ios-sdk/issues/233) related to parsing `deepLink` for new app installs. In order to get it work your dynamic link MUST have an [app preview page](https://firebase.google.com/docs/dynamic-links/link-previews), which by default.

## Methods

### onDynamicLink(_callback_)
Registers callback that is triggered on each dynamic link click.
```js
window.cordova.plugins.firebase.dynamiclinks.onDynamicLink(function(data) {
    console.log("Dynamic link click with data: ", data);
});
```

[npm-url]: https://www.npmjs.com/package/cordova-plugin-firebase-dynamiclinks
[npm-version]: https://img.shields.io/npm/v/cordova-plugin-firebase-dynamiclinks.svg
[npm-downloads]: https://img.shields.io/npm/dt/cordova-plugin-firebase-dynamiclinks.svg

