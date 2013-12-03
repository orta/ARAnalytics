//
//  ARAnalytics+GoogleAnalytics.h
//  ARAnalyticsTests
//
//  Created by orta therox on 16/03/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "ARAnalytics.h"

@interface ARAnalytics (GoogleAnalytics)

/// Use the full Google Analytics syntax for an event
+ (void)event:(NSString *)event withCategory:(NSString *)category withLabel:(NSString *)label withValue:(NSNumber *)value;

/// Build a generic properties dictionary that uses the Google Analytics syntax
+ (NSDictionary *)dictionaryWithCategory:(NSString *)category;
+ (NSDictionary *)dictionaryWithCategory:(NSString *)category withLabel:(NSString *)label;
+ (NSDictionary *)dictionaryWithCategory:(NSString *)category withLabel:(NSString *)label withValue:(NSNumber *)value;

/// Send social events
+ (void)socialEvent:(NSString *)event onNetwork:(NSString *)network withAddress:(NSString *)address;

/// It says what it does on the tin
+ (void)sendUncaughtExceptionsToGoogleAnalytics;

/// Enable output of debugging logs
+ (void)enableGoogleAnalyticsDebuggingLogs:(BOOL)enabled;

@end
