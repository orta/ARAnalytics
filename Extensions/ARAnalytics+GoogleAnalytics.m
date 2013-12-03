//
//  ARAnalytics+GoogleAnalytics.m
//  ARAnalyticsTests
//
//  Created by orta therox on 16/03/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "ARAnalytics+GoogleAnalytics.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "NSDictionary+GoogleAnalytics.h"

@implementation ARAnalytics (GoogleAnalytics)

+ (void)event:(NSString *)event withCategory:(NSString *)category withLabel:(NSString *)label withValue:(NSNumber *)value {
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:category
                                                                           action:event
                                                                            label:label
                                                                            value:value];
    [[[GAI sharedInstance] defaultTracker] send:[builder build]];
}

+ (NSDictionary *)dictionaryWithCategory:(NSString *)category {
    return [NSDictionary dictionaryWithCategory:category];
}

+ (NSDictionary *)dictionaryWithCategory:(NSString *)category withLabel:(NSString *)label {
    return [NSDictionary dictionaryWithCategory:category withLabel:label];
}

+ (NSDictionary *)dictionaryWithCategory:(NSString *)category withLabel:(NSString *)label withValue:(NSNumber *)value {
    return [NSDictionary dictionaryWithCategory:category withLabel:label withValue:value];
}

+ (void)socialEvent:(NSString *)event onNetwork:(NSString *)network withAddress:(NSString *)address {
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createSocialWithNetwork:network
                                                                           action:event
                                                                           target:address];
    [[[GAI sharedInstance] defaultTracker] send:[builder build]];
}

+ (void)sendUncaughtExceptionsToGoogleAnalytics {
    [GAI sharedInstance].trackUncaughtExceptions = YES;
}

+ (void)enableGoogleAnalyticsDebuggingLogs:(BOOL)enabled {
    GAILogLevel logLevel;
    if (enabled)
    {
        logLevel = kGAILogLevelVerbose;
    } else
    {
        logLevel = kGAILogLevelWarning; // Google Analytics' default log level
    }
    [ [GAI sharedInstance].logger setLogLevel:logLevel];
}

@end
