#import "FirebaseDynamicLinksPlugin.h"

@implementation FirebaseDynamicLinksPlugin

- (void)pluginInitialize {
    NSLog(@"Starting Firebase DynamicLinks plugin");

    if (![FIRApp defaultApp]) {
        [FIRApp configure];
    }

    self.domainUriPrefix = [self.commandDelegate.settings objectForKey:[@"DOMAIN_URI_PREFIX" lowercaseString]];
}

- (void)getDynamicLink:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult;
    if (self.lastDynamicLinkData) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:self.lastDynamicLinkData];

        self.lastDynamicLinkData = nil;
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)onDynamicLink:(CDVInvokedUrlCommand *)command {
    self.dynamicLinkCallbackId = command.callbackId;
}

- (void)createDynamicLink:(CDVInvokedUrlCommand *)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    int linkType = [[command.arguments objectAtIndex:1] intValue];
    FIRDynamicLinkComponents *linkBuilder = [self createDynamicLinkBuilder:params];

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

- (FIRDynamicLinkComponents*) createDynamicLinkBuilder:(NSDictionary*) params {
    NSURL* link = [[NSURL alloc] initWithString:params[@"link"]];
    NSString* domainUriPrefix = params[@"domainUriPrefix"];
    if (!domainUriPrefix) {
        domainUriPrefix = self.domainUriPrefix;
    }

    FIRDynamicLinkComponents *linkBuilder = [[FIRDynamicLinkComponents alloc]
                                             initWithLink:link domainURIPrefix:domainUriPrefix];
    NSDictionary* androidInfo = params[@"androidInfo"];
    if (androidInfo) {
        linkBuilder.androidParameters = [self getAndroidParameters:androidInfo];
    }
    NSDictionary* iosInfo = params[@"iosInfo"];
    if (iosInfo) {
        linkBuilder.iOSParameters = [self getIosParameters:iosInfo];
    }
    NSDictionary* navigationInfo = params[@"navigationInfo"];
    if (navigationInfo) {
        linkBuilder.navigationInfoParameters = [self getNavigationInfoParameters:navigationInfo];
    }
    NSDictionary* analyticsInfo = params[@"analyticsInfo"];
    if (analyticsInfo) {
        NSDictionary* googlePlayAnalyticsInfo = params[@"googlePlayAnalytics"];
        if (googlePlayAnalyticsInfo) {
            linkBuilder.analyticsParameters = [self getGoogleAnalyticsParameters:googlePlayAnalyticsInfo];
        }
        NSDictionary* itunesConnectAnalyticsInfo = params[@"itunesConnectAnalytics"];
        if (itunesConnectAnalyticsInfo) {
            linkBuilder.iTunesConnectParameters = [self getItunesConnectAnalyticsParameters:itunesConnectAnalyticsInfo];
        }
    }
    NSDictionary* socialMetaTagInfo = params[@"socialMetaTagInfo"];
    if (socialMetaTagInfo) {
        linkBuilder.socialMetaTagParameters = [self getSocialMetaTagParameters:socialMetaTagInfo];
    }
    return linkBuilder;
}

- (FIRDynamicLinkAndroidParameters*) getAndroidParameters:(NSDictionary*) androidInfo {
    FIRDynamicLinkAndroidParameters* result = [[FIRDynamicLinkAndroidParameters alloc]
                                     initWithPackageName:androidInfo[@"androidPackageName"]];
    NSNumber* minimumVersion = androidInfo[@"androidMinPackageVersionCode"];
    if (minimumVersion) {
        result.minimumVersion = [minimumVersion intValue];
    }
    NSString* androidFallbackLink = androidInfo[@"androidFallbackLink"];
    if (androidFallbackLink) {
        result.fallbackURL = [[NSURL alloc] initWithString:androidFallbackLink];
    }
    return result;
}

- (FIRDynamicLinkIOSParameters*) getIosParameters:(NSDictionary*) iosInfo {
    FIRDynamicLinkIOSParameters* result = [[FIRDynamicLinkIOSParameters alloc]
                                 initWithBundleID:iosInfo[@"iosBundleId"]];
    result.appStoreID = iosInfo[@"iosAppStoreId"];
    result.iPadBundleID = iosInfo[@"iosIpadBundleId"];
    result.minimumAppVersion = iosInfo[@"iosMinPackageVersion"];
    NSString* iosFallbackLink = iosInfo[@"iosFallbackLink"];
    if (iosFallbackLink) {
        result.fallbackURL = [[NSURL alloc] initWithString:iosFallbackLink];
    }
    NSString* iosIpadFallbackLink = iosInfo[@"iosIpadFallbackLink"];
    if (iosIpadFallbackLink) {
        result.iPadFallbackURL = [[NSURL alloc] initWithString:iosIpadFallbackLink];
    }
    return result;
}

- (FIRDynamicLinkNavigationInfoParameters*) getNavigationInfoParameters:(NSDictionary*) navigationInfo {
    FIRDynamicLinkNavigationInfoParameters* result = [[FIRDynamicLinkNavigationInfoParameters alloc] init];
    NSNumber* forcedRedirectEnabled = navigationInfo[@"enableForcedRedirect"];
    if (forcedRedirectEnabled) {
        result.forcedRedirectEnabled = [forcedRedirectEnabled boolValue];
    }
    return result;
}

- (FIRDynamicLinkGoogleAnalyticsParameters*) getGoogleAnalyticsParameters:(NSDictionary*) googlePlayAnalyticsInfo {
    FIRDynamicLinkGoogleAnalyticsParameters* result = [[FIRDynamicLinkGoogleAnalyticsParameters alloc] init];
    result.source = googlePlayAnalyticsInfo[@"utmSource"];
    result.medium = googlePlayAnalyticsInfo[@"utmMedium"];
    result.campaign = googlePlayAnalyticsInfo[@"utmCampaign"];
    result.content = googlePlayAnalyticsInfo[@"utmContent"];
    result.term = googlePlayAnalyticsInfo[@"utmTerm"];
    return result;
}

- (FIRDynamicLinkItunesConnectAnalyticsParameters*) getItunesConnectAnalyticsParameters:(NSDictionary*) itunesConnectAnalyticsInfo {
    FIRDynamicLinkItunesConnectAnalyticsParameters* result = [[FIRDynamicLinkItunesConnectAnalyticsParameters alloc] init];
    result.affiliateToken = itunesConnectAnalyticsInfo[@"at"];
    result.campaignToken = itunesConnectAnalyticsInfo[@"ct"];
    result.providerToken = itunesConnectAnalyticsInfo[@"pt"];
    return result;
}

- (FIRDynamicLinkSocialMetaTagParameters*) getSocialMetaTagParameters:(NSDictionary*) socialMetaTagInfo {
    FIRDynamicLinkSocialMetaTagParameters* result = [[FIRDynamicLinkSocialMetaTagParameters alloc] init];
    result.title = socialMetaTagInfo[@"socialTitle"];
    result.descriptionText = socialMetaTagInfo[@"socialDescription"];
    NSString* socialImageLink = socialMetaTagInfo[@"socialImageLink"];
    if (socialImageLink) {
        result.imageURL = [[NSURL alloc] initWithString:socialImageLink];
    }
    return result;
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
