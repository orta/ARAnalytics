#import "ARAnalyticalProvider.h"

extern NSString const *AdobeProviderCallsTrackStateForPageViewsWithProperties;

@interface AdobeProvider : ARAnalyticalProvider

- (instancetype)initWithData:(NSDictionary *)additionalData;
- (instancetype)initWithData:(NSDictionary *)additionalData settings:(NSDictionary*)settings;

@end
