#import "AppDelegate.h"

@interface AppDelegate (FirebaseDynamicLinksPlugin)

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options;
- (BOOL)application:(UIApplication *)app continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler;

@end
