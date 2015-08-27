//
//  ARAnalyticalProvider.h
//  ARAnalytics
//

#import "ARAnalyticalProvider.h"

@interface ParseAnalyticsProvider : ARAnalyticalProvider

- (instancetype)initWithApplicationID:(NSString *)applicationId clientKey:(NSString *)clientKey;

@end
