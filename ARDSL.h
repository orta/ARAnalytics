#import "ARAnalytics.h"

#define ARAnalyticsSelector(name) NSStringFromSelector(@selector(name))

extern NSString * const ARAnalyticsTrackedEvents;
extern NSString * const ARAnalyticsTrackedScreens;

extern NSString * const ARAnalyticsClass;
extern NSString * const ARAnalyticsDetails;
extern NSString * const ARAnalyticsProperties;
extern NSString * const ARAnalyticsPageName;
extern NSString * const ARAnalyticsPageNameBlock;
extern NSString * const ARAnalyticsPageNameKeyPath;
extern NSString * const ARAnalyticsEventName;
extern NSString * const ARAnalyticsEventNameBlock;
extern NSString * const ARAnalyticsSelectorName;
extern NSString * const ARAnalyticsEventProperties __attribute__((deprecated("Renamed to ARAnalyticsProperties")));
extern NSString * const ARAnalyticsShouldFire;

/**
 * Optionally supply an NSDictionary of custom properties at the time a screen view or event is triggered. This is the
 * value type used for the ARAnalyticsProperties key.
 */
typedef NSDictionary*(^ARAnalyticsPropertiesBlock)(id instance, NSArray *arguments);
/**
 * ARAnalyticsNameBlock is used to dynamically supply a pageName or eventName at the time the screen view or event/action
 * is triggered. This is the value type used for the ARAnalyticsPageNameBlock or ARAnalyticsEventNameBlock keys.
 *
 * Often times, the tracked screen or event name is a derivative of the custom tracking parameters. The customProperties
 * parameter contains the dictionary, if any, supplied by the ARAnalyticsProperties block
 */
typedef NSString*(^ARAnalyticsNameBlock)(id instance, NSArray *arguments, NSDictionary *customProperties);
typedef ARAnalyticsPropertiesBlock ARAnalyticsEventPropertiesBlock __attribute__((deprecated("Renamed to ARAnalyticsPropertiesBlock")));

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
