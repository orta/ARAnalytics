//
//  ARDSL.h
//  Artsy
//
//  Created by Ash Furrow on 04/29/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARAnalytics.h"

extern NSString * const ARAnalyticsTrackedEvents;
extern NSString * const ARAnalyticsTrackedScreens;

extern NSString * const ARAnalyticsClass;
extern NSString * const ARAnalyticsDetails;
extern NSString * const ARAnalyticsPageName;
extern NSString * const ARAnalyticsPageNameKeyPath;
extern NSString * const ARAnalyticsEventName;
extern NSString * const ARAnalyticsSelectorName;
extern NSString * const ARAnalyticsEventProperties;
extern NSString * const ARAnalyticsShouldFire;

typedef NSDictionary*(^ARAnalyticsEventPropertiesBlock)(id instance, NSArray *arguments);
typedef BOOL(^ARAnalyticsEventShouldFireBlock)(id instance, NSArray *arguments);

@interface ARAnalytics (DSL)

/**
 *  Startup your ARAnalytics instance with an additional DSL for triggering calls after methods are done
 *
 *  @param analyticsDictionary     The normal ARAnalytics dictionary with provider keys & secrets
 *  @param configurationDictionary A dictionary consisting of ARAnalyticsTrackedEvents & ARAnalyticsTrackedScreens
 *  @see                           addEventAnalyticsHooks, addScreenMonitoringAnalyticsHook
 */

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary;

/**
 *  Register a new hook in ARAnalytics
 *
 *  @param analyticsDictionary A dictionary with two keys, ARAnalyticsClass which takes a class
 *                          saying what to to hook into and ARAnalyticsDetails holding details
 *                          like ARAnalyticsSelectorName / ARAnalyticsEventName / 
 *                               ARAnalyticsEventProperties / ARAnalyticsShouldFire
 */
+ (void)addEventAnalyticsHooks:(NSDictionary *)analyticsDictionary;

/**
 *  Remove a hook in from ARAnalytics, user-code will nit be touched
 *
 *  @param analyticsDictionary Same formatted dictionary as addEventAnalyticsHooks
 *
 *  @return Whether removal was successful
 */
+ (BOOL)removeEventsAnalyticsHooks:(NSDictionary *)analyticsDictionary;

/**
 *  Add a screen monitoring Analytics hook at runtime
 *
 *  @param screenDictionary A dictionary with two keys, ARAnalyticsClass which takes a class
 *                          for the class to hook into and ARAnalyticsDetails holding details
 *                          like ARAnalyticsSelectorName / ARAnalyticsEventName / ARAnalyticsEventProperties.
 */
+ (void)addScreenMonitoringAnalyticsHook:(NSDictionary *)screenDictionary;

/**
 *  Remove a screen monitoring analytics hook at runtime
 *
 *  @param screenDictionary A dictionary with two keys, ARAnalyticsClass which takes a class
 *                          for the class to hook into and ARAnalyticsSelectorName passing the
 *                          selector as a string.
 *
 *  @return Whether the removal was a success
 */
+ (BOOL)removeScreenMonitoringAnalyticsHooks:(NSDictionary *)screenDictionary;

/**
 *  Remove all DSL based analytics calls
 *
 *  @return Whether all of removals were successful
 */
+ (BOOL)removeAllAnalyticsHooks;

@end
