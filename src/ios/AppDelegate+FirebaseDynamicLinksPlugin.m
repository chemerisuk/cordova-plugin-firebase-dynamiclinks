#import "AppDelegate+FirebaseDynamicLinksPlugin.h"
#import "FirebaseDynamicLinksPlugin.h"
#import <objc/runtime.h>


@implementation AppDelegate (FirebaseDynamicLinksPlugin)

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    FirebaseDynamicLinksPlugin* dl = [self.viewController getCommandInstance:@"FirebaseDynamicLinks"];
    FIRDynamicLink *dynamicLink = [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];

    if (dynamicLink) {
        [dl postDynamicLink:dynamicLink];
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)app continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    FirebaseDynamicLinksPlugin* dl = [self.viewController getCommandInstance:@"FirebaseDynamicLinks"];

    return [[FIRDynamicLinks dynamicLinks]
        handleUniversalLink:userActivity.webpageURL
        completion:^(FIRDynamicLink * _Nullable dynamicLink, NSError * _Nullable error) {
            // Try this method as some dynamic links are not recognize by handleUniversalLink
            // ISSUE: https://github.com/firebase/firebase-ios-sdk/issues/743
            dynamicLink = dynamicLink ? dynamicLink
                : [[FIRDynamicLinks dynamicLinks]
                   dynamicLinkFromUniversalLinkURL:userActivity.webpageURL];

            if (dynamicLink) {
                [dl postDynamicLink:dynamicLink];
            }
        }];
}

@end
