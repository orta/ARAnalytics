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
    [Adjust appDidLaunch:identifier];
    
#if defined (DEBUG)
    [Adjust setEnvironment:AIEnvironmentSandbox];
#else
    [Adjust setEnvironment:AIEnvironmentProduction];
#endif
    
    return [super init];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [Adjust trackEvent:event withParameters:properties];
}





@end
