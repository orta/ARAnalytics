//
//  AdjustProvider.m
//
//  Created by Engin Kurutepe on 10/11/2014.
//  Copyright (c) 2014 Engin Kurutepe. All rights reserved.
//

#import "AdjustProvider.h"
#import "ARAnalyticsProviders.h"
#import "Adjust.h"

@implementation AdjustProvider

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([Adjust class], @"Adjust is not included");

    NSString *environment;
    ADJConfig *adjustConfig;

#if defined (DEBUG)
    environment = ADJEnvironmentSandbox;
#else
    environment = ADJEnvironmentProduction;
#endif

    adjustConfig = [ADJConfig configWithAppToken:identifier
                                     environment:environment];

    [Adjust appDidLaunch:adjustConfig];

    return [super init];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {

    ADJEvent *const adjustEvent = [ADJEvent eventWithEventToken:event];

    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [adjustEvent addCallbackParameter:key value:value];
    }];

    [Adjust trackEvent:adjustEvent];
}

@end
