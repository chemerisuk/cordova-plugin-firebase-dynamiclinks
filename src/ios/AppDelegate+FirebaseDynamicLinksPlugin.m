#import "AppDelegate+FirebaseDynamicLinksPlugin.h"
#import "FirebaseDynamicLinksPlugin.h"
#import <objc/runtime.h>


@implementation AppDelegate (FirebaseDynamicLinksPlugin)

// Borrowed from http://nshipster.com/method-swizzling/
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(application:continueUserActivity:restorationHandler:);
        SEL swizzledSelector = @selector(identity_application:continueUserActivity:restorationHandler:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

// [START continueuseractivity]
- (BOOL)identity_application:(UIApplication *)application
        continueUserActivity:(NSUserActivity *)userActivity
          restorationHandler:(void (^)(NSArray *))restorationHandler {
    FirebaseDynamicLinksPlugin* dl = [self.viewController getCommandInstance:@"FirebaseDynamicLinks"];

    BOOL handled = [[FIRDynamicLinks dynamicLinks]
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

    if (handled) {
        return YES;
    }

    return [self identity_application:application
                 continueUserActivity:userActivity
                   restorationHandler:restorationHandler];
}
// [END continueuseractivity]

@end
