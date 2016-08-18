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

- (instancetype)initWithIdentifier:(NSString *)identifier {
    return [self initWithIdentifier:identifier andConfigurationDelegate:nil];
}

-(instancetype)initWithIdentifier:(NSString *)identifier andConfigurationDelegate:(id<AdjustDelegate>)delegate {
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
    adjustConfig.delegate = delegate;
    
    [Adjust appDidLaunch:adjustConfig];
    
    return [super init];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {

    ADJEvent *const adjustEvent = [ADJEvent eventWithEventToken:event];

    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        // Adjust assumes value is a string, so if it's not convert it to a string value
        if (![value isKindOfClass:[NSString class]]) {
            if ([value respondsToSelector:@selector(stringValue)]) {
                value = [value stringValue];
            } else {
                value = [value description];
            }
        }
        [adjustEvent addCallbackParameter:key value:value];
    }];

    [Adjust trackEvent:adjustEvent];
}

@end
