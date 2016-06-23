//
//  SegmentioProvider.h
//
//

#import "ARAnalyticalProvider.h"

@interface SwrveProvider : ARAnalyticalProvider

- (instancetype)initWithAppID:(NSString *)appID apiKey:(NSString *)apiKey;

@end
