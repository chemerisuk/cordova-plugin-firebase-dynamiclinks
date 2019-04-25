#import "FirebaseDynamicLinksPlugin.h"

@implementation FirebaseDynamicLinksPlugin

- (void)pluginInitialize {
    NSLog(@"Starting Firebase DynamicLinks plugin");

    if (![FIRApp defaultApp]) {
        [FIRApp configure];
    }
}

- (void)handleOpenURL:(NSNotification*)notification {
    NSURL* url = [notification object];

    if ([url isKindOfClass:[NSURL class]]) {
        FIRDynamicLink* dynamicLink =
            [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];

        if (dynamicLink) {
            [self postDynamicLink:dynamicLink];
        }
    }
}

- (void)onDynamicLink:(CDVInvokedUrlCommand *)command {
    self.dynamicLinkCallbackId = command.callbackId;

    if (self.cachedDynamicLinkData) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:self.cachedDynamicLinkData];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.dynamicLinkCallbackId];

        self.cachedDynamicLinkData = nil;
    }
}

- (void)postDynamicLink:(FIRDynamicLink*) dynamicLink {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSString* absoluteUrl = dynamicLink.url.absoluteString;
    NSString* minimumAppVersion = dynamicLink.minimumAppVersion;
    BOOL weakConfidence = (dynamicLink.matchType == FIRDLMatchTypeWeak);

    [data setObject:(absoluteUrl ? absoluteUrl : @"") forKey:@"deepLink"];
    [data setObject:(minimumAppVersion ? minimumAppVersion : @"") forKey:@"minimumAppVersion"];
    [data setObject:(weakConfidence ? @"Weak" : @"Strong") forKey:@"matchType"];

    if (self.dynamicLinkCallbackId) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:data];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.dynamicLinkCallbackId];
    } else {
        self.cachedDynamicLinkData = data;
    }
}

@end
