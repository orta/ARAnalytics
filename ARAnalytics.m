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

+ (void)setup {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{ _sharedAnalytics = [[ARAnalytics alloc] init]; } );
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
}

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
}


+ (void)error:(NSString*)string, ... {}


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
