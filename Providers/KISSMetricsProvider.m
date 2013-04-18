//
//  KISSMetricsProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "KISSMetricsProvider.h"
#import "KISSMetricsAPI.h"

@implementation KISSMetricsProvider
#ifdef AR_KISSMETRICS_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([KISSMetricsAPI class], @"KISSMetrics is not included");
    [KISSMetricsAPI sharedAPIWithKey:identifier];

    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (email && userID) {
    	[[KISSMetricsAPI sharedAPI] identify:userID];
        [[KISSMetricsAPI sharedAPI] alias:email withIdentity:userID];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [[KISSMetricsAPI sharedAPI] setProperties:@{property: value}];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[KISSMetricsAPI sharedAPI] recordEvent:event withProperties:properties];
}

#endif
@end
