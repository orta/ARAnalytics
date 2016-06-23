#import "InstallTrackerProvider.h"
#import "ARAnalyticsProviders.h"
#import "InstallTracker.h"

@implementation InstallTrackerProvider
#ifdef AR_INSTALLTRACKER_EXISTS

- (instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([InstallTracker class], @"InstallTracker is not included");
    [InstallTracker setApplicationID:identifier];

    return [super init];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [InstallTracker sendEvent:event];
}

+ (void)setLoggerEnable:(BOOL)flag {
    [InstallTracker setLoggerEnable:flag];
}

#endif
@end
