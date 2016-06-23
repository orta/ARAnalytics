#import "UMengAnalyticsProvider.h"
#import "ARAnalyticsProviders.h"
#import <UMMobClick/MobClick.h>

@implementation UMengAnalyticsProvider
#ifdef AR_UMENGANALYTICS_EXISTS

- (instancetype)initWithIdentifier:(NSString *)identifier {
	NSAssert([MobClick class], @"MobClick is not included");
    UMAnalyticsConfig *config = [UMAnalyticsConfig sharedInstance];
	config.appKey = identifier;
	config.bCrashReportEnabled = NO;
	[MobClick startWithConfigure:config];

	return [super init];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
	[MobClick event:event attributes:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
	[self event:@"Screen view" withProperties:@{ @"screen": pageTitle }];

	// support Umeng's logPageView logic by set a fixed 
	[MobClick logPageView:pageTitle seconds:0.1];
}

/// Submit an event with a time interval
- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval {
	[MobClick event:event durations:(int)([interval doubleValue]*1000)];
}

/// Submit an event with a time interval and extra properties
/// @warning the properites must not contain the key string `length`.
- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval properties:(NSDictionary *)properties {
	[MobClick event:event attributes:properties durations:(int)([interval doubleValue]*1000)];
}

#endif
@end
