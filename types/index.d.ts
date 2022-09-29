interface CordovaPlugins {
    firebase: FirebasePlugins;
}

interface FirebasePlugins {
    dynamiclinks: typeof import("./FirebaseDynamicLinks");
}
