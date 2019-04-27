#import "FirebaseDynamicLinksPlugin.h"

@implementation FirebaseDynamicLinksPlugin

- (void)pluginInitialize {
    NSLog(@"Starting Firebase DynamicLinks plugin");

    if (![FIRApp defaultApp]) {
        [FIRApp configure];
    }

    self.domainUriPrefix = [self.commandDelegate.settings objectForKey:[@"DYNAMIC_LINK_URIPREFIX" lowercaseString]];
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

    if (self.lastDynamicLinkData) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:self.lastDynamicLinkData];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.dynamicLinkCallbackId];

        self.lastDynamicLinkData = nil;
    }
}

- (void)createDynamicLink:(CDVInvokedUrlCommand *)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    int linkType = [[command.arguments objectAtIndex:1] intValue];

    NSURL* link = [[NSURL alloc] initWithString:params[@"link"]];
    NSString* domainUriPrefix = params[@"domainUriPrefix"];
    if (!domainUriPrefix) {
        domainUriPrefix = self.domainUriPrefix;
    }

    FIRDynamicLinkComponents *linkBuilder = [[FIRDynamicLinkComponents alloc]
                                             initWithLink:link domainURIPrefix:domainUriPrefix];
    NSDictionary* androidInfo = params[@"androidInfo"];
    if (androidInfo) {
        linkBuilder.androidParameters = [[FIRDynamicLinkAndroidParameters alloc]
                                         initWithPackageName:androidInfo[@"androidPackageName"]];
        NSNumber* minimumVersion = androidInfo[@"androidMinPackageVersionCode"];
        if (minimumVersion) {
            linkBuilder.androidParameters.minimumVersion = [minimumVersion intValue];
        }
        NSString* androidFallbackLink = androidInfo[@"androidFallbackLink"];
        if (androidFallbackLink) {
            linkBuilder.androidParameters.fallbackURL = [[NSURL alloc] initWithString:androidFallbackLink];
        }
    }

    NSDictionary* iosInfo = params[@"iosInfo"];
    if (iosInfo) {
        linkBuilder.iOSParameters = [[FIRDynamicLinkIOSParameters alloc]
                                     initWithBundleID:iosInfo[@"iosBundleId"]];
        linkBuilder.iOSParameters.appStoreID = iosInfo[@"iosAppStoreId"];
        linkBuilder.iOSParameters.iPadBundleID = iosInfo[@"iosIpadBundleId"];
        linkBuilder.iOSParameters.minimumAppVersion = iosInfo[@"iosMinPackageVersion"];
        NSString* iosFallbackLink = iosInfo[@"iosFallbackLink"];
        if (iosFallbackLink) {
            linkBuilder.iOSParameters.fallbackURL = [[NSURL alloc] initWithString:iosFallbackLink];
        }
        NSString* iosIpadFallbackLink = iosInfo[@"iosIpadFallbackLink"];
        if (iosIpadFallbackLink) {
            linkBuilder.iOSParameters.iPadFallbackURL = [[NSURL alloc] initWithString:iosIpadFallbackLink];
        }
    }

    NSDictionary* navigationInfo = params[@"navigationInfo"];
    if (navigationInfo) {
        linkBuilder.navigationInfoParameters = [[FIRDynamicLinkNavigationInfoParameters alloc] init];
        NSNumber* forcedRedirectEnabled = navigationInfo[@"enableForcedRedirect"];
        if (forcedRedirectEnabled) {
            linkBuilder.navigationInfoParameters.forcedRedirectEnabled = [forcedRedirectEnabled boolValue];
        }
    }

    NSDictionary* analyticsInfo = params[@"analyticsInfo"];
    if (analyticsInfo) {
        NSDictionary* googlePlayAnalyticsInfo = params[@"googlePlayAnalytics"];
        if (googlePlayAnalyticsInfo) {
            linkBuilder.analyticsParameters = [[FIRDynamicLinkGoogleAnalyticsParameters alloc] init];
            linkBuilder.analyticsParameters.source = googlePlayAnalyticsInfo[@"utmSource"];
            linkBuilder.analyticsParameters.medium = googlePlayAnalyticsInfo[@"utmMedium"];
            linkBuilder.analyticsParameters.campaign = googlePlayAnalyticsInfo[@"utmCampaign"];
            linkBuilder.analyticsParameters.content = googlePlayAnalyticsInfo[@"utmContent"];
            linkBuilder.analyticsParameters.term = googlePlayAnalyticsInfo[@"utmTerm"];
        }

        NSDictionary* itunesConnectAnalyticsInfo = params[@"itunesConnectAnalytics"];
        if (itunesConnectAnalyticsInfo) {
            linkBuilder.iTunesConnectParameters = [[FIRDynamicLinkItunesConnectAnalyticsParameters alloc] init];
            linkBuilder.iTunesConnectParameters.affiliateToken = itunesConnectAnalyticsInfo[@"at"];
            linkBuilder.iTunesConnectParameters.campaignToken = itunesConnectAnalyticsInfo[@"ct"];
            linkBuilder.iTunesConnectParameters.providerToken = itunesConnectAnalyticsInfo[@"pt"];
        }
    }

    NSDictionary* socialMetaTagInfo = params[@"socialMetaTagInfo"];
    if (socialMetaTagInfo) {
        linkBuilder.socialMetaTagParameters = [[FIRDynamicLinkSocialMetaTagParameters alloc] init];
        linkBuilder.socialMetaTagParameters.title = socialMetaTagInfo[@"socialTitle"];
        linkBuilder.socialMetaTagParameters.descriptionText = socialMetaTagInfo[@"socialDescription"];
        NSString* socialImageLink = socialMetaTagInfo[@"socialImageLink"];
        if (socialImageLink) {
            linkBuilder.socialMetaTagParameters.imageURL = [[NSURL alloc] initWithString:socialImageLink];
        }
    }

    if (linkType == 0) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:linkBuilder.url.absoluteString];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
        linkBuilder.options = [[FIRDynamicLinkComponentsOptions alloc] init];
        linkBuilder.options.pathLength = linkType;

        [linkBuilder shortenWithCompletion:^(NSURL * _Nullable shortURL,
                                             NSArray<NSString *> * _Nullable warnings,
                                             NSError * _Nullable error) {
            CDVPluginResult *pluginResult;
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            } else if (shortURL) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:shortURL.absoluteString];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
            }
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
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
        self.lastDynamicLinkData = data;
    }
}

@end
