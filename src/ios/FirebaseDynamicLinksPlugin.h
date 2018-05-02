#import <Cordova/CDV.h>
#import "AppDelegate.h"

@import Firebase;

@interface FirebaseDynamicLinksPlugin : CDVPlugin

- (void)onDynamicLink:(CDVInvokedUrlCommand *)command;
- (void)postDynamicLink:(FIRDynamicLink*) dynamicLink;

@property (nonatomic, copy) NSString *dynamicLinkCallbackId;
@property (nonatomic, retain) NSDictionary* cachedDynamicLinkData;

@end
