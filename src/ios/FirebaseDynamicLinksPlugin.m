#import "FirebaseDynamicLinksPlugin.h"

@implementation FirebaseDynamicLinksPlugin

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

- (void)createReferralLink:(CDVInvokedUrlCommand *)command {
    self.dynamicLinkCallbackId = command.callbackId;
    NSString* referralURL = [command.arguments objectAtIndex:0];
    NSString* dynamicLinksDomain = [command.arguments objectAtIndex:1];
    NSString* iOSBundleID = [command.arguments objectAtIndex:2];
    NSString* iOSAppStoreID = [command.arguments objectAtIndex:3];
    NSString* androidPackageName = [command.arguments objectAtIndex:4];
    if (referralURL != nil && dynamicLinksDomain != nil && iOSBundleID != nil && iOSAppStoreID != nil && androidPackageName != nil) {
        NSURL *link = [[NSURL alloc] initWithString:referralURL];
        FIRDynamicLinkComponents *linkBuilder = [[FIRDynamicLinkComponents alloc]
                                                 initWithLink:link
                                                 domain:dynamicLinksDomain];
        linkBuilder.iOSParameters = [[FIRDynamicLinkIOSParameters alloc]
                                     initWithBundleID:iOSBundleID];
        linkBuilder.iOSParameters.appStoreID = iOSAppStoreID;
        linkBuilder.androidParameters = [[FIRDynamicLinkAndroidParameters alloc]
                                         initWithPackageName:androidPackageName];
        
        [linkBuilder shortenWithCompletion:^(NSURL * _Nullable shortURL,
                                             NSArray<NSString *> * _Nullable warnings,
                                             NSError * _Nullable error) {
            if (error || shortURL == nil) {
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:self.dynamicLinkCallbackId];
                return;
            }
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:shortURL.absoluteString] callbackId:self.dynamicLinkCallbackId];
        }];
    } else {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:self.dynamicLinkCallbackId];
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
