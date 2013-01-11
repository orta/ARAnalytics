//
//  ARAnalytics.m
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//

#import "ARAnalytics.h"
#import "ARAnalytics+GeneratedHeader.h"
#import "ARAnalyticalProvider.h"
#import "ARAnalyticsProviders.h"

static ARAnalytics *_sharedAnalytics;

@interface ARAnalytics ()
@property (strong) NSMutableDictionary *eventsDictionary;
@property (strong) NSSet *providers;
@end

@implementation ARAnalytics

+ (void) initialize {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _sharedAnalytics = [[ARAnalytics alloc] init];
        _sharedAnalytics.providers = [NSSet set];
    });
}

#pragma mark -
#pragma mark Analytics Setup

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary {
#ifdef AR_TESTFLIGHT_EXISTS
    if (analyticsDictionary[ARTestFlightAppToken]) {
        [self setupTestFlightWithAppToken:analyticsDictionary[ARTestFlightAppToken]];
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
        [self setupMixpanelWithToken:analyticsDictionary[ARMixpanelToken] andHost:analyticsDictionary[ARMixpanelHost]];
    }
#endif

#ifdef AR_COUNTLY_EXISTS
    if (analyticsDictionary[ARCountlyAppKey] && analyticsDictionary[ARCountlyHost]) {
        [self setupCountlyWithAppKey:analyticsDictionary[ARCountlyAppKey] andHost:analyticsDictionary[ARCountlyHost]];
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

+ (void)setupTestFlightWithAppToken:(NSString *)token {
    TestFlightProvider *provider = [[TestFlightProvider alloc] initWithIdentifier:token];
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];
}

+ (void)setupCrashlyticsWithAPIKey:(NSString *)key {
    CrashlyticsProvider *provider = [[CrashlyticsProvider alloc] initWithIdentifier:key];
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];
}

+ (void)setupMixpanelWithToken:(NSString *)token {
    [self setupMixpanelWithToken:token andHost:nil];
}

+ (void)setupMixpanelWithToken:(NSString *)token andHost:(NSString *)host {
    MixpanelProvider *provider = [[MixpanelProvider alloc] initWithIdentifier:token andHost:host];
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];
}

+ (void)setupFlurryWithAPIKey:(NSString *)key {
    FlurryProvider *provider = [[FlurryProvider alloc] initWithIdentifier:key];
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];
}

+ (void)setupGoogleAnalyticsWithID:(NSString *)id {
    GoogleProvider *provider = [[GoogleProvider alloc] initWithIdentifier:id];
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];
}

+ (void)setupLocalyticsWithAppKey:(NSString *)key {
    LocalyticsProvider *provider = [[LocalyticsProvider alloc] initWithIdentifier:key];
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];}

+ (void)setupKISSMetricsWithAPIKey:(NSString *)key {
    KISSMetricsProvider *provider = [[KISSMetricsProvider alloc] initWithIdentifier:key];
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];
}

+ (void)setupCrittercismWithAppID:(NSString *)appID {
    CrittercismProvider *provider = [[CrittercismProvider alloc] initWithIdentifier:appID];
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];
}

+ (void)setupCountlyWithAppKey:(NSString *)key andHost:(NSString *)host {
    CountlyProvider *provider = [[CountlyProvider alloc] initWithAppKey:key andHost:host];
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];
}

#pragma mark -
#pragma mark User Setup


+ (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider identifyUserwithID:id andEmailAddress:email];
    }];
}

+ (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    if (value == nil) {
        NSLog(@"ARAnalytics: Value cannot be nil ( %@ ) ", property);
        return;
    }

    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider setUserProperty:property toValue:value];
    }];
}

+ (void)incrementUserProperty:(NSString *)counterName byInt:(int)amount {
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider incrementUserProperty:counterName byInt:@(amount)];
    }];
}

#pragma mark -
#pragma mark Events


+ (void)event:(NSString *)event {
    [self event:event withProperties:nil];
}

+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider event:event withProperties:properties];
    }];
}

#pragma mark -
#pragma mark Monitor Navigation Controller

+ (void)monitorNavigationViewController:(UINavigationController *)controller {
    controller.delegate = _sharedAnalytics;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider didShowNewViewController:viewController];
    }];
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
    [_sharedAnalytics.eventsDictionary removeObjectForKey:event];

    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider logTimingEvent:event withInterval:@(eventInterval)];
    }];
}


#pragma mark -
#pragma mark Util

- (void)iterateThroughProviders:(void(^)(ARAnalyticalProvider *provider))providerBlock {
    for (ARAnalyticalProvider *provider in _providers) {
        providerBlock(provider);
    }
}

@end

void ARLog (NSString *format, ...) {
    if (format == nil) {
        printf("nil \n");
        return;
    }
    // Get a reference to the arguments that follow the format parameter
    va_list argList;
    va_start(argList, format);
    // Perform format string argument substitution, reinstate %% escapes, then print
    NSString *parsedFormatString = [[NSString alloc] initWithFormat:format arguments:argList];
    parsedFormatString = [parsedFormatString stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"];
    printf("ARLog : %s\n", parsedFormatString.UTF8String);

    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider remoteLog:parsedFormatString];
    }];

    va_end(argList);
}

const NSString *ARCountlyAppKey = @"ARCountlyAppKey";
const NSString *ARCountlyHost = @"ARCountlyHost";
const NSString *ARTestFlightAppToken = @"ARTestFlight";
const NSString *ARCrashlyticsAPIKey = @"ARCrashlytics";
const NSString *ARMixpanelToken = @"ARMixpanel";
const NSString *ARMixpanelHost = @"ARMixpanelHost";
const NSString *ARFlurryAPIKey = @"ARFlurry";
const NSString *ARLocalyticsAppKey = @"ARLocalytics";
const NSString *ARKISSMetricsAPIKey = @"ARKISSMetrics";
const NSString *ARCrittercismAppID = @"ARCrittercism";
const NSString *ARGoogleAnalyticsID = @"ARGoogleAnalytics";
