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
@property (strong) NSArray *providers;
@end

@implementation ARAnalytics

+ (void) initialize {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{ 
        _sharedAnalytics = [[ARAnalytics alloc] init];
        _sharedAnalytics.providers = [NSArray array];
    });
}

#pragma mark -
#pragma mark Analytics Setup

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary {
#ifdef AR_TESTFLIGHT_EXISTS
    if (analyticsDictionary[ARTestFlightAppToken]) {
        [self setupTestFlightWithTeamToken:analyticsDictionary[ARTestFlightAppToken]];
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
    TestFlightProvider *provider = [[TestFlightProvider alloc] initWithIdentifier:token];
    _sharedAnalytics.providers = [_sharedAnalytics.providers arrayByAddingObject:provider];
}

+ (void)setupCrashlyticsWithAPIKey:(NSString *)key {
    CrashlyticsProvider *provider = [[CrashlyticsProvider alloc] initWithIdentifier:key];
    _sharedAnalytics.providers = [_sharedAnalytics.providers arrayByAddingObject:provider];
}

+ (void)setupMixpanelWithToken:(NSString *)token {
    MixpanelProvider *provider = [[MixpanelProvider alloc] initWithIdentifier:token];
    _sharedAnalytics.providers = [_sharedAnalytics.providers arrayByAddingObject:provider];
}

+ (void)setupFlurryWithAPIKey:(NSString *)key {
    FlurryProvider *provider = [[FlurryProvider alloc] initWithIdentifier:key];
    _sharedAnalytics.providers = [_sharedAnalytics.providers arrayByAddingObject:provider];
}

+ (void)setupGoogleAnalyticsWithID:(NSString *)id {
    GoogleProvider *provider = [[GoogleProvider alloc] initWithIdentifier:id];
    _sharedAnalytics.providers = [_sharedAnalytics.providers arrayByAddingObject:provider];
}

+ (void)setupLocalyticsWithAppKey:(NSString *)key {
    LocalyticsProvider *provider = [[LocalyticsProvider alloc] initWithIdentifier:key];
    _sharedAnalytics.providers = [_sharedAnalytics.providers arrayByAddingObject:provider];
}

+ (void)setupKISSMetricsWithAPIKey:(NSString *)key {
    KISSMetricsProvider *provider = [[KISSMetricsProvider alloc] initWithIdentifier:key];
    _sharedAnalytics.providers = [_sharedAnalytics.providers arrayByAddingObject:provider];
}

+ (void)setupCrittercismWithAppID:(NSString *)appID {
    CrittercismProvider *provider = [[CrittercismProvider alloc] initWithIdentifier:appID];
    _sharedAnalytics.providers = [_sharedAnalytics.providers arrayByAddingObject:provider];
}


#pragma mark -
#pragma mark User Setup


+ (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
    [_sharedAnalytics makeProvidorsPerformSelector:@selector(identifyUserwithID:andEmailAddress:) withObject:id and:email];
}

+ (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    if (value == nil) {
        NSLog(@"ARAnalytics: Value cannot be nil ( %@ ) ", property);
        return;
    }

    [_sharedAnalytics makeProvidorsPerformSelector:@selector(setUserProperty:toValue:) withObject:property and:value];
}

+ (void)incrementUserProperty:(NSString *)counterName byInt:(int)amount {
    [_sharedAnalytics makeProvidorsPerformSelector:@selector(incrementUserProperty:byInt:) withObject:counterName and:@(amount)];
}

#pragma mark -
#pragma mark Events


+ (void)event:(NSString *)event {
    [self event:event withProperties:nil];
}

+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [_sharedAnalytics makeProvidorsPerformSelector:@selector(event:withProperties:) withObject:event and:properties];
}

#pragma mark -
#pragma mark Monitor Navigation Controller

+ (void)monitorNavigationViewController:(UINavigationController *)controller {
    controller.delegate = _sharedAnalytics;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [_sharedAnalytics makeProvidorsPerformSelector:@selector(didShowNewViewController:) withObject:viewController and:nil];

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
    
    [_sharedAnalytics makeProvidorsPerformSelector:@selector(logTimingEvent:withInterval:) withObject:event and:@(eventInterval)];
}


#pragma mark -
#pragma mark Util

- (void)makeProvidorsPerformSelector:(SEL)selector withObject:(id)object1 and:(id)object2 {
    for (ARAnalyticalProvider *provider in _providers) {
        NSMethodSignature *methodSignature = [provider methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.target = provider;
        invocation.selector = selector;
        [invocation setArgument:&object1 atIndex:0];
        if (object2) {
            [invocation setArgument:&object2 atIndex:1];
        }
        [invocation invoke];
    }
}


@end

NSString *const ARTestFlightAppToken = @"ARTestFlight";
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

    [_sharedAnalytics makeProvidorsPerformSelector:@selector(remoteLog:) withObject:string and:nil];

    va_end(argList);
}