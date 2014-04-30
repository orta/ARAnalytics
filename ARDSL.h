//
//  ARDSL.h
//  Artsy
//
//  Created by Ash Furrow on 04/29/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import <ARAnalytics/ARAnalytics.h>

// Top-level keys
extern NSString * const ARAnalyticsTrackedEvents;
extern NSString * const ARAnalyticsTrackedScreens;

extern NSString * const ARAnalyticsClass;
extern NSString * const ARAnalyticsPageName;
extern NSString * const ARAnalyticsPageNameKeyPath;
extern NSString * const ARAnalyticsEventName;
extern NSString * const ARAnalyticsSelectorName; // Note: selector must return void
extern NSString * const ARAnalyticsEventProperties;
extern NSString * const ARAnalyticsShouldFire;

typedef NSDictionary*(^ARAnalyticsEventPropertiesBlock)(id instance);
typedef BOOL(^ARAnalyticsEventShouldFireBlock)(id instance);

@interface ARAnalytics (DSL)

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary;

@end
