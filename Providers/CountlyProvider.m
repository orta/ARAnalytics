//
//  CountlyProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "CountlyProvider.h"
#import "Countly.h"

@implementation CountlyProvider

- (id)initWithAppKey:(NSString *)appKey andHost:(NSString *)host {
#ifdef AR_COUNTLY_EXISTS
    NSAssert([Countly class], @"Countly is not included");
    [[Countly sharedInstance] start:appKey withHost:host];
#endif

    return [super init];
}

#ifdef AR_COUNTLY_EXISTS

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[Countly sharedInstance] recordEvent:event count:1];
}

#endif
@end
