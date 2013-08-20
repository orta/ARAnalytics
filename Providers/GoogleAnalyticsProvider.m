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

@interface GoogleAnalyticsProvider ()
@property (nonatomic, strong) id<GAITracker> tracker;
@end

@implementation GoogleAnalyticsProvider
#ifdef AR_GOOGLEANALYTICS_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([GAI class], @"Google Analytics SDK is not included");
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:identifier];

    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    // Not allowed in GA
    // https://developers.google.com/analytics/devguides/collection/ios/v3/customdimsmets#pii

    // The Google Analytics Terms of Service prohibit sending of any personally identifiable information (PII) to Google Analytics servers. For more information, please consult the Terms of Service.
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [self.tracker set:property value:value];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:nil
                                                                           action:event
                                                                            label:nil
                                                                            value:nil];
    [self.tracker send:[builder build]];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [self event:@"Screen view" withProperties:@{ @"screen": pageTitle }];
    [self.tracker set:kGAIScreenName value:pageTitle];
    [self.tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval {
    [self event:event withProperties:@{ @"length": interval }];
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createTimingWithCategory:nil
                                                                          interval:interval
                                                                              name:event
                                                                             label:nil];
    [self.tracker send:[builder build]];
}

#endif
@end
