//
//  ARAnalytics.m
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//

#import "ARAnalytics.h"
#import "ARAnalytics+GeneratedHeader.h"

@class Crashlytics, TestFlight, Mixpanel;
static ARAnalytics *_sharedAnalytics;

@interface ARAnalytics ()
@property (strong) TestFlight *testflight;
@property (strong) Mixpanel *mixpanel;
@end

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

+ (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
#ifdef AR_MIXPANEL_EXISTS
    [_sharedAnalytics.mixpanel.people identify:id];
    [_sharedAnalytics.mixpanel.people set:@"$email" to:email];
#endif

#ifdef AR_TESTFLIGHT_EXISTS
    [TestFlight addCustomEnvironmentInformation:@"id" forKey:id];
    [TestFlight addCustomEnvironmentInformation:@"email" forKey:email];
#endif
}

+ (void)event:(NSString *)event {}
+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties {}

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
