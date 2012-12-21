//
//  ARAnalytics.m
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//

#import "ARAnalytics.h"
#import "ARAnalytics+GeneratedHeader.h"

static ARAnalytics *_sharedAnalytics;

// Things to look at: Timed Events, AB Tests, Setup with dictionary

@implementation ARAnalytics

+ (void) initialize {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{ _sharedAnalytics = [[ARAnalytics alloc] init]; } );
}


#pragma mark -
#pragma mark Analytics Setup

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary {
#ifdef AR_TESTFLIGHT_EXISTS
    if (analyticsDictionary[ARTestFlightkey]) {
        [self setupTestFlightWithTeamToken:analyticsDictionary[ARTestFlightkey]];
    }
#endif

#ifdef AR_CRASHLYTICS_EXISTS
    if (analyticsDictionary[ARCrashlyticsKey]) {
        [self setupCrashlyticsWithAPIKey:analyticsDictionary[ARCrashlyticsKey]];
    }
#endif

#ifdef AR_CRITTERCISM_EXISTS
    if (analyticsDictionary[ARCrittercismKey]) {
       [self setupCrittercismWithAppID:analyticsDictionary[ARCrittercismKey]];
    }
#endif

#ifdef AR_FLURRY_EXISTS
    if (analyticsDictionary[ARFlurryKey]) {
        [self setupFlurryWithAPIKey:analyticsDictionary[ARFlurryKey]];
    }
#endif

#ifdef AR_GOOGLEANALYTICS_EXISTS
    if (analyticsDictionary[ARGoogleAnalyticsKey]) {
        [self setupGoogleAnalyticsWithID:analyticsDictionary[ARGoogleAnalyticsKey]];
    }
#endif

#ifdef AR_KISSMETRICS_EXISTS
    if (analyticsDictionary[ARKISSMetricsKey]) {
        [self setupKissMetricsWithAPIKey:analyticsDictionary[ARKISSMetricsKey]];
    }
#endif

#ifdef AR_LOCALYTICS_EXISTS
    if (analyticsDictionary[ARLocalyticsKey]) {
        [self setupLocalyticsWithAppKey:analyticsDictionary[ARLocalyticsKey]];
    }
#endif

#ifdef AR_MIXPANEL_EXISTS
    if (analyticsDictionary[ARMixpanelKey]) {
        [self setupMixpanelWithToken:analyticsDictionary[ARMixpanelKey]];
    }
#endif
}

+ (void)setupTestFlightWithTeamToken:(NSString *)token {
#ifdef AR_TESTFLIGHT_EXISTS
    NSAssert([TestFlight class], @"TestFlight is not included");

    // For non App store builds use a device identifier.
#ifndef RELEASE
    [TestFlight setDeviceIdentifier:[self uniqueID]];
#endif
    [TestFlight takeOff:token];
#endif
}

+ (void)setupCrashlyticsWithAPIKey:(NSString *)key {
#ifdef AR_CRASHLYTICS_EXISTS
    NSAssert([Crashlytics class], @"Crashlytics is not included");
    NSAssert([[Crashlytics class] respondsToSelector:@selector(version)], @"Crashlytics library not installed correctly.");
    [Crashlytics startWithAPIKey:key];
#endif
}

+ (void)setupMixpanelWithToken:(NSString *)token {
#ifdef AR_MIXPANEL_EXISTS
    NSAssert([Mixpanel class], @"Mixpanel is not included");
    [Mixpanel sharedInstanceWithToken:token];
#endif
}

+ (void)setupFlurryWithAPIKey:(NSString *)key {
#ifdef AR_FLURRY_EXISTS
    NSAssert([Flurry class], @"Flurry is not included");
    [Flurry startSession:key];
#endif
}

+ (void)setupGoogleAnalyticsWithID:(NSString *)id {
#ifdef AR_GOOGLEANALYTICS_EXISTS
    NSAssert([GAI class], @"Google Analytics SDK is not included");
    [[GAI sharedInstance] trackerWithTrackingId:id];
#endif
}

+ (void)setupLocalyticsWithAppKey:(NSString *)key {
#ifdef AR_LOCALYTICS_EXISTS
    NSAssert([LocalyticsSession class], @"Localytics is not included");
    [[LocalyticsSession sharedLocalyticsSession] startSession:key];
#endif
}

+ (void)setupKissMetricsWithAPIKey:(NSString *)key {
#ifdef AR_KISSMETRICS_EXISTS
    NSAssert([KISSMetricsAPI class], @"KISSMetrics is not included");
    [KISSMetricsAPI sharedAPIWithKey:key];
#endif
}

+ (void)setupCrittercismWithAppID:(NSString *)appID {
#ifdef AR_CRITTERCISM_EXISTS
    NSAssert([Crittercism class], @"Crittercism is not included");
    [Crittercism enableWithAppID:appID];
#endif
}


#pragma mark -
#pragma mark User Setup


+ (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
#ifdef AR_MIXPANEL_EXISTS
    [[[Mixpanel sharedInstance] people] identify:id];
    [[[Mixpanel sharedInstance] people] set:@"$email" to:email];
#endif

#ifdef AR_TESTFLIGHT_EXISTS
    [TestFlight addCustomEnvironmentInformation:@"id" forKey:id];
    [TestFlight addCustomEnvironmentInformation:@"email" forKey:email];
#endif

#ifdef AR_FLURRY_EXISTS
    [Flurry setUserID:id];
#endif

#ifdef AR_LOCALYTICS_EXISTS
    [[LocalyticsSession sharedLocalyticsSession] setCustomerEmail:email];
    [[LocalyticsSession sharedLocalyticsSession] setCustomerName:id];
#endif

#ifdef AR_GOOGLEANALYTICS_EXISTS
    // Not allowed in GA
    // https://developers.google.com/analytics/devguides/collection/ios/v2/customdimsmets#pii

    // The Google Analytics Terms of Service prohibit sending of any personally identifiable information (PII) to Google Analytics servers. For more information, please consult the Terms of Service.
#endif

#ifdef AR_CRASHLYTICS_EXISTS
    [Crashlytics setUserIdentifier:email];
    [Crashlytics setUserName:id];
#endif

#ifdef AR_CRITTERCISM_EXISTS
    [Crittercism setUsername:id];
    [Crittercism setEmail:email];
#endif

#ifdef AR_KISSMETRICS_EXISTS
    [[KISSMetricsAPI sharedAPI] identify:id];
    [[KISSMetricsAPI sharedAPI] alias:email withIdentity:id];
#endif
}

+ (void)addUserProperty:(NSString *)property toValue:(NSString *)value {
#ifdef AR_MIXPANEL_EXISTS
    [[[Mixpanel sharedInstance] people] set:property to:value];
#endif

#ifdef AR_TESTFLIGHT_EXISTS
    [TestFlight addCustomEnvironmentInformation:value forKey:property];
#endif

#ifdef AR_FLURRY_EXISTS
    // This concept doesn't exist in Flurry
#endif

#ifdef AR_LOCALYTICS_EXISTS
    // This is for enterprise only...
    [[LocalyticsSession sharedLocalyticsSession] setValueForIdentifier:property value:value];
#endif

#ifdef AR_GOOGLEANALYTICS_EXISTS
    [[[GAI sharedInstance] defaultTracker] set:property value:value];
#endif

#ifdef AR_CRASHLYTICS_EXISTS
    [Crashlytics setObjectValue:value forKey:property];
#endif

#ifdef AR_KISSMETRICS_EXISTS
    [[KISSMetricsAPI sharedAPI] setProperties:@{property: value}];
#endif

#ifdef AR_CRITTERCISM_EXISTS
    [Crittercism setValue:value forKey:property];
#endif
}


#pragma mark -
#pragma mark Events


+ (void)event:(NSString *)event {
    [self event:event withProperties:nil];
}

+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
#ifdef AR_MIXPANEL_EXISTS
    [[Mixpanel sharedInstance] track:event properties:properties];
#endif

#ifdef AR_TESTFLIGHT_EXISTS
    [TestFlight passCheckpoint:@"Event"];
#endif

#ifdef AR_FLURRY_EXISTS
    [Flurry logEvent:event withParameters:properties];
#endif

#ifdef AR_LOCALYTICS_EXISTS
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:event attributes:properties];
#endif

#ifdef AR_GOOGLEANALYTICS_EXISTS
    [[[GAI sharedInstance] defaultTracker] send:event params:properties];
#endif

#ifdef AR_CRASHLYTICS_EXISTS
    // This concept doesn't exist in Crashlytics
#endif

#ifdef AR_KISSMETRICS_EXISTS
    [[KISSMetricsAPI sharedAPI] recordEvent:event withProperties:properties];
#endif

#ifdef AR_CRITTERCISM_EXISTS
    [Crittercism leaveBreadcrumb:event];
#endif
}


#pragma mark -
#pragma mark Monitor Navigation Controller


+ (void)monitorNavigationViewController:(UINavigationController *)controller {
    controller.delegate = _sharedAnalytics;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    [ARAnalytics event:@"Screen view" withProperties:@{ @"screen": viewController.title }];

#ifdef AR_LOCALYTICS_EXISTS
    // This is for enterprise only...
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:viewController.title];
#endif

#ifdef AR_GOOGLEANALYTICS_EXISTS
    [[[GAI sharedInstance] defaultTracker] trackView:viewController.title];
#endif

}

// Util
+ (NSString *)uniqueID {
    // iOS 6 has a good API for getting a unique ID 
    if ([UICollectionView class] != nil) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        [[UIDevice currentDevice] identifierForVendor];
    }
}

@end

NSString *const ARTestFlightkey = @"ARTestFlight";
NSString *const ARCrashlyticsKey = @"ARCrashlytics";
NSString *const ARMixpanelKey = @"ARMixpanel";
NSString *const ARFlurryKey = @"ARFlurry";
NSString *const ARLocalyticsKey = @"ARLocalytics";
NSString *const ARKISSMetricsKey = @"ARKISSMetrics";
NSString *const ARCrittercismKey = @"ARCrittercism";
NSString *const ARGoogleAnalyticsKey = @"ARGoogleAnalytics";