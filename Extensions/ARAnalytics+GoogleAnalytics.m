//
//  ARAnalytics+GoogleAnalytics.m
//  ARAnalyticsTests
//
//  Created by orta therox on 16/03/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "ARAnalytics+GoogleAnalytics.h"
#import "GAI.h"

@implementation ARAnalytics (GoogleAnalytics)

+ (void)event:(NSString *)event withCategory:(NSString *)category withLabel:(NSString *)label withValue:(NSNumber *)value {
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:category withAction:event withLabel:label withValue:value];
}

+ (void)socialEvent:(NSString *)event onNetwork:(NSString *)network withAddress:(NSString *)address {
    [[[GAI sharedInstance] defaultTracker] sendSocial:network withAction:event withTarget:address];
}

+ (void)sendUncaughtExceptionsToGoogleAnalytics {
    [GAI sharedInstance].sendUncaughtExceptions = YES;
}

@end
