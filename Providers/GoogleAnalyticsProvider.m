//
//  GoogleProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "GoogleAnalyticsProvider.h"
#import "ARAnalyticsProviders.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "NSDictionary+GoogleAnalytics.h"

@interface GoogleAnalyticsProvider ()

@property (nonatomic, strong) id <GAITracker> tracker;

- (void) dispatchGA;

@end

@implementation GoogleAnalyticsProvider
#ifdef AR_GOOGLEANALYTICS_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([GAI class], @"Google Analytics SDK is not included");

    if ((self = [super init])) {
        self.tracker = [[GAI sharedInstance] trackerWithTrackingId:identifier];

        for( NSString *inactiveEvent in @[ UIApplicationWillResignActiveNotification,
                                           UIApplicationWillTerminateNotification,
                                           UIApplicationDidEnterBackgroundNotification ]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(dispatchGA)
                                                         name:inactiveEvent
                                                       object:nil];
        }
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    // Not allowed in GA
    // https://developers.google.com/analytics/devguides/collection/ios/v3/customdimsmets#pii

    // The Google Analytics Terms of Service prohibit sending of any personally identifiable information (PII) to Google Analytics servers. For more information, please consult the Terms of Service.

    // Ideally we would put an assert here but if you have multiple providers that wouldn't make sense.
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [self.tracker set:property value:value];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSString *category = properties.category;
    if (!category) {
        category = @"default"; // category is a required value
    }
    
#ifdef DEBUG
    [self warnAboutIgnoredProperies:properties];
#endif
    
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:category
                                                                           action:event
                                                                            label:properties.label
                                                                            value:properties.value];

    [self.tracker send:[builder build]];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [self event:@"Screen view" withProperties:@{ @"label": pageTitle }];
    [self.tracker set:kGAIScreenName value:pageTitle];
    [self.tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval  properties:(NSDictionary *)properties{
    // Prepare properties dictionary
    if (!properties) {
        properties = @{ @"value": @([interval intValue]) };
    } else {
        NSMutableDictionary *newProperties = [properties mutableCopy];
        newProperties[@"value"] = @([interval intValue]);
        properties = newProperties;
    }
    
    // Send event
    [self event:event withProperties:properties];
    
    // By Google's header, the interval should be seconds in milliseconds.
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createTimingWithCategory:@"default"
                                                                          interval:@((int)([interval doubleValue]*1000))
                                                                              name:event
                                                                             label:nil];
    [self.tracker send:[builder build]];
}

#pragma mark - Dispatch

- (void)dispatchGA {
    [[GAI sharedInstance] dispatch];
}

#pragma mark - Warnings

-(void) warnAboutIgnoredProperies:(NSDictionary*)propertiesDictionary
{
    for (id key in propertiesDictionary) {
        if (    [key isEqualToString:[NSDictionary googleAnalyticsLabelKey]] ||
                [key isEqualToString:[NSDictionary googleAnalyticsCategoryKey]] ||
                [key isEqualToString:[NSDictionary googleAnalyticsValueKey]]
            ) {
            continue;
        }
        NSLog(@"%@: property ignored %@:%@",self,key,propertiesDictionary[key]);
    }
}

#endif
@end
