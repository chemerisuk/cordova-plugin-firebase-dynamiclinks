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
    CDVPluginResult* pluginResult = nil;
    NSString* referralURL = [command.arguments objectAtIndex:0];
    if (referralURL != nil) {
        NSURL *link = [[NSURL alloc] initWithString:referralURL];
        NSString *dynamicLinksDomain = @"newstandtesting.page.link";
        FIRDynamicLinkComponents *linkBuilder = [[FIRDynamicLinkComponents alloc]
                                                 initWithLink:link
                                                 domain:dynamicLinksDomain];
        linkBuilder.iOSParameters = [[FIRDynamicLinkIOSParameters alloc]
                                     initWithBundleID:@"com.the-new-stand.TheNewStand"];
        linkBuilder.iOSParameters.appStoreID = @"962188372";
        linkBuilder.androidParameters = [[FIRDynamicLinkAndroidParameters alloc]
                                     initWithPackageName:@"com.the_new_stand.TheNewStand"];

        NSLog(@"The long URL is: %@", linkBuilder.url);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Link created!"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.dynamicLinkCallbackId];
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
