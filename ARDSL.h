//
//  ARDSL.h
//  Artsy
//
//  Created by Ash Furrow on 04/29/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import <ARAnalytics/ARAnalytics.h>

extern NSString * const ARAnalyticsTrackedEvents;
extern NSString * const ARAnalyticsTrackedScreens;

extern NSString * const ARAnalyticsTrackedClassName;
extern NSString * const ARAnalyticsTrackedLabel;
extern NSString * const ARAnalyticsTriggeringSelector; // Note: selector must return void

@interface ARAnalytics (DSL)

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary;

@end
