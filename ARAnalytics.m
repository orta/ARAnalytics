//
//  ARAnalytics.m
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//

#import "ARAnalytics.h"
#import "ARAnalytics+GeneratedHeader.h"

@protocol GAITracker @end
@class Crashlytics, TestFlight, Mixpanel;
static ARAnalytics *_sharedAnalytics;

@interface ARAnalytics ()
@property (strong) TestFlight *testflight;
@property (strong) Mixpanel *mixpanel;

@property (strong) NSObject <GAITracker> *gaTracker;
@end

// Things to look at: Timed Events, AB Tests, Setup with dictionary

@implementation ARAnalytics

+ (void)setup {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{ _sharedAnalytics = [[ARAnalytics alloc] init]; } );
}

+ (void)setupTestFlightWithTeamToken:(NSString *)token {
    NSAssert([TestFlight class], @"TestFlight is not included");

    // For non App store builds use a device identifier.
#ifndef RELEASE
    [TestFlight setDeviceIdentifier:[self uniqueID]];
#endif
    [TestFlight takeOff:token];
}

+ (void)setupCrashlyticsWithAPIKey:(NSString *)key {
    NSAssert([Crashlytics class], @"Crashlytics is not included");
    [Crashlytics startWithAPIKey:key];
}

+ (void)setupMixpanelWithToken:(NSString *)token {
    NSAssert([Mixpanel class], @"Mixpanel is not included");
    _sharedAnalytics.mixpanel = [Mixpanel sharedInstanceWithToken:token];
}

+ (void)setupFlurryWithAPIKey:(NSString *)key {
    NSAssert([Flurry class], @"Flurry is not included");
    [Flurry startSession:key];
}

+ (void)setupGoogleAnalyticsWithID:(NSString *)id {
    NSAssert([GAI class], @"Google Analytics SDK is not included");
    [[GAI sharedInstance] trackerWithTrackingId:id];
}

+ (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
#ifdef AR_MIXPANEL_EXISTS
    [_sharedAnalytics.mixpanel.people identify:id];
    [_sharedAnalytics.mixpanel.people set:@"$email" to:email];
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
    [_sharedAnalytics.mixpanel track:event properties:properties];
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
    [_sharedAnalytics.gaTracker send:event params:properties];
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
