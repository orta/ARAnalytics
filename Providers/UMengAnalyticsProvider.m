//
//  UMengAnalyticsProvider.m
//  ARAnalyticsTests
//
//  Created by Cai Guo on 08/05/2014.
//
//

#import "UMengAnalyticsProvider.h"
#import "ARAnalyticsProviders.h"
#import "MobClick.h"

@implementation UMengAnalyticsProvider
#ifdef AR_UMENGANALYTICS_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
	NSAssert([MobClick class], @"MobClick is not included");
	[MobClick startWithAppkey:identifier];

	return [super init];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
	[MobClick event:event attributes:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
	[self event:@"Screen view" withProperties:@{ @"screen": pageTitle }];
	[MobClick beginLogPageView:pageTitle];
}

/// Submit an event with a time interval
- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval {
	[MobClick event:event durations:interval.intValue];
}

/// Submit an event with a time interval and extra properties
/// @warning the properites must not contain the key string `length`.
- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval properties:(NSDictionary *)properties {
	[MobClick event:event attributes:properties durations:interval.intValue];
}

#endif
@end
