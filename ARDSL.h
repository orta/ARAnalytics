#import "ARAnalytics.h"

#define ARAnalyticsSelector(name) NSStringFromSelector(@selector(name))

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
 */

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary;

@end
