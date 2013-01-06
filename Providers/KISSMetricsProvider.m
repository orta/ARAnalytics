//
//  KISSMetricsProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "KISSMetricsProvider.h"

@implementation KISSMetricsProvider
#ifdef AR_GOOGLEANALYTICS_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([KISSMetricsAPI class], @"KISSMetrics is not included");
    [KISSMetricsAPI sharedAPIWithKey:identifier];

    self = [super init];
    return self;
}

- (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
    [[KISSMetricsAPI sharedAPI] identify:id];
    if (email) {
        [[KISSMetricsAPI sharedAPI] alias:email withIdentity:id];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [[KISSMetricsAPI sharedAPI] setProperties:@{property: value}];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[KISSMetricsAPI sharedAPI] recordEvent:event withProperties:properties];
}

- (void)didShowNewViewController:(UIViewController *)controller {
    [self event:@"Screen view" withProperties:@{ @"screen": controller.title }];
}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval {
    [self event:event withProperties:@{ @"length": interval }];
}

#endif
@end
