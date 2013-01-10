//
//  ARAnalytics.h
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.



#import <Foundation/Foundation.h>
#import "ARAnalytics+GeneratedHeader.h"

extern void ARLog (NSString *format, ...);

@interface ARAnalytics : NSObject <UINavigationControllerDelegate>

// A global analytics API, use the constants at the bottom for keys.
+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary;

/// Setup methods for each individual analytics type
+ (void)setupTestFlightWithAppToken:(NSString *)token;
+ (void)setupCrashlyticsWithAPIKey:(NSString *)key;
+ (void)setupMixpanelWithToken:(NSString *)token;
+ (void)setupMixpanelWithToken:(NSString *)token andHost:(NSString *)host;
+ (void)setupFlurryWithAPIKey:(NSString *)key;
+ (void)setupGoogleAnalyticsWithID:(NSString *)id;
+ (void)setupLocalyticsWithAppKey:(NSString *)key;
+ (void)setupKISSMetricsWithAPIKey:(NSString *)key;
+ (void)setupCrittercismWithAppID:(NSString *)appID;
+ (void)setupCountlyWithAppKey:(NSString *)key andHost:(NSString *)host;

/// Set a per user property
+ (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email;
+ (void)setUserProperty:(NSString *)property toValue:(NSString *)value;

/// Submit user events
+ (void)event:(NSString *)event;
+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties;
+ (void)incrementUserProperty:(NSString*)counterName byInt:(int)amount;

/// Monitor Navigation changes as page view
+ (void)monitorNavigationViewController:(UINavigationController *)controller;

/// Let ARAnalytics deal with the timing of an event
+ (void)startTimingEvent:(NSString *)event;
+ (void)finishTimingEvent:(NSString *)event;

// Upcoming:
// Blacklist developers or testers from your main analytics
//+ (void)setupBlacklistAnalyticsProviders:(NSDictionary *)blacklistAnalyticsDictionary;
//+ (void)userIDsForBlacklist:(NSArray *)ids;
//+ (void)userEmailsForBlacklist:(NSArray *)emails;

@end


// Provide some keys for the setupWithDictionary
extern const NSString *ARCountlyAppKey;
extern const NSString *ARCountlyHost;
extern const NSString *ARTestFlightAppToken;
extern const NSString *ARCrashlyticsAPIKey;
extern const NSString *ARMixpanelToken;
extern const NSString *ARMixpanelHost;
extern const NSString *ARFlurryAPIKey;
extern const NSString *ARLocalyticsAppKey;
extern const NSString *ARKISSMetricsAPIKey;
extern const NSString *ARCrittercismAppID;
extern const NSString *ARGoogleAnalyticsID;
