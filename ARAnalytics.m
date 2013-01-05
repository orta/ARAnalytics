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

@interface ARAnalytics ()
@property (strong) NSMutableDictionary *eventsDictionary;
@property (strong) NSArray *providers;
@end

@implementation ARAnalytics

+ (void) initialize {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{ 
        _sharedAnalytics = [[ARAnalytics alloc] init];
        _sharedAnalytics.providers = [NSMutableArray array];
    });
}


#pragma mark -
#pragma mark Analytics Setup

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary {
#ifdef AR_TESTFLIGHT_EXISTS
    if (analyticsDictionary[ARTestFlightTeamToken]) {
        [self setupTestFlightWithTeamToken:analyticsDictionary[ARTestFlightTeamToken]];
    }
#endif

#ifdef AR_FLURRY_EXISTS
    if (analyticsDictionary[ARFlurryAPIKey]) {
        [self setupFlurryWithAPIKey:analyticsDictionary[ARFlurryAPIKey]];
    }
#endif

#ifdef AR_GOOGLEANALYTICS_EXISTS
    if (analyticsDictionary[ARGoogleAnalyticsID]) {
        [self setupGoogleAnalyticsWithID:analyticsDictionary[ARGoogleAnalyticsID]];
    }
#endif

#ifdef AR_KISSMETRICS_EXISTS
    if (analyticsDictionary[ARKISSMetricsAPIKey]) {
        [self setupKISSMetricsWithAPIKey:analyticsDictionary[ARKISSMetricsAPIKey]];
    }
#endif

#ifdef AR_LOCALYTICS_EXISTS
    if (analyticsDictionary[ARLocalyticsAppKey]) {
        [self setupLocalyticsWithAppKey:analyticsDictionary[ARLocalyticsAppKey]];
    }
#endif

#ifdef AR_MIXPANEL_EXISTS
    if (analyticsDictionary[ARMixpanelToken]) {
        [self setupMixpanelWithToken:analyticsDictionary[ARMixpanelToken]];
    }
#endif

// Crashlytics / Crittercism should stay at the bottom of this,
// as they both need to register exceptions, and you'd only use one.

#ifdef AR_CRASHLYTICS_EXISTS
    if (analyticsDictionary[ARCrashlyticsAPIKey]) {
        [self setupCrashlyticsWithAPIKey:analyticsDictionary[ARCrashlyticsAPIKey]];
    }
#endif

#ifdef AR_CRITTERCISM_EXISTS
    if (analyticsDictionary[ARCrittercismAppID]) {
        [self setupCrittercismWithAppID:analyticsDictionary[ARCrittercismAppID]];
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

+ (void)setupKISSMetricsWithAPIKey:(NSString *)key {
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
    if (email) {
        [[[Mixpanel sharedInstance] people] set:@"$email" to:email];
    }
#endif

#ifdef AR_TESTFLIGHT_EXISTS
    [TestFlight addCustomEnvironmentInformation:@"id" forKey:id];
    if (email) {
        [TestFlight addCustomEnvironmentInformation:@"email" forKey:email];
    }
#endif

#ifdef AR_FLURRY_EXISTS
    [Flurry setUserID:id];
#endif

#ifdef AR_LOCALYTICS_EXISTS
    [[LocalyticsSession sharedLocalyticsSession] setCustomerName:id];
    if (email) {
        [[LocalyticsSession sharedLocalyticsSession] setCustomerEmail:email];
    }
#endif

#ifdef AR_GOOGLEANALYTICS_EXISTS
    // Not allowed in GA
    // https://developers.google.com/analytics/devguides/collection/ios/v2/customdimsmets#pii

    // The Google Analytics Terms of Service prohibit sending of any personally identifiable information (PII) to Google Analytics servers. For more information, please consult the Terms of Service.
#endif

#ifdef AR_CRASHLYTICS_EXISTS
    [Crashlytics setUserIdentifier:id];
    if (email) {
        [Crashlytics setUserName:email];
    }
#endif

#ifdef AR_CRITTERCISM_EXISTS
    [Crittercism setUsername:id];
    if (email) {
        [Crittercism setEmail:email];
    }
#endif

#ifdef AR_KISSMETRICS_EXISTS
    [[KISSMetricsAPI sharedAPI] identify:id];
    if (email) {
        [[KISSMetricsAPI sharedAPI] alias:email withIdentity:id];
    }
#endif
}

+ (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    if (value == nil) {
        NSLog(@"ARAnalytics: Value cannot be nil ( %@ ) ", property);
        return;
    }
    
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

+ (void)incrementUserProperty:(NSString*)counterName byInt:(int)amount {
    //TODO: Reasearch if others support this
#ifdef AR_MIXPANEL_EXISTS
    [[[Mixpanel sharedInstance] people] increment:counterName by:@(amount)];
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
    [TestFlight passCheckpoint:event];
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

#ifdef AR_FLURRY_EXISTS
    [Flurry logAllPageViews:controller];
#endif
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

#pragma mark -
#pragma mark Timing Events

+ (void)startTimingEvent:(NSString *)event {
    if (!_sharedAnalytics.eventsDictionary) {
        _sharedAnalytics.eventsDictionary = [NSMutableDictionary dictionary];
    }
    _sharedAnalytics.eventsDictionary[event] = [NSDate date];
}

+ (void)finishTimingEvent:(NSString *)event {
    NSDate *startDate = _sharedAnalytics.eventsDictionary[event];
    if (!startDate) {
        NSLog(@"ARAnalytics: finish timing event called without a corrosponding start timing event");
        return;
    }

    NSTimeInterval eventInterval = [[NSDate date] timeIntervalSinceDate:startDate];
    [self event:event withProperties:@{ @"length": @(eventInterval) }];
}


#pragma mark -
#pragma mark Util

+ (NSString *)uniqueID {
    // iOS 6 has a good API for getting a unique ID
    if ([UICollectionView class] != nil) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        [[UIDevice currentDevice] uniqueIdentifier];
    }
}

@end


NSString *const ARTestFlightTeamToken = @"ARTestFlight";
NSString *const ARCrashlyticsAPIKey = @"ARCrashlytics";
NSString *const ARMixpanelToken = @"ARMixpanel";
NSString *const ARFlurryAPIKey = @"ARFlurry";
NSString *const ARLocalyticsAppKey = @"ARLocalytics";
NSString *const ARKISSMetricsAPIKey = @"ARKISSMetrics";
NSString *const ARCrittercismAppID = @"ARCrittercism";
NSString *const ARGoogleAnalyticsID = @"ARGoogleAnalytics";

void ARLog (NSString *format, ...) {
    if (format == nil) {
        printf("nil \n");
        return;
    }
    // Get a reference to the arguments that follow the format parameter
    va_list argList;
    va_start(argList, format);
    // Perform format string argument substitution, reinstate %% escapes, then print
    NSString *string = [[NSString alloc] initWithFormat:format arguments:argList];
    string = [string stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"];
    printf("ARLog : %s\n", string.UTF8String);

#ifdef AR_CRASHLYTICS_EXISTS
    CLSLog(@"%@", string);
#endif

#ifdef AR_TESTFLIGHT_EXISTS
    TFLog(@"%@",string);
#endif

    va_end(argList);
}