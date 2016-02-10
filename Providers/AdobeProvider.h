#import "ARAnalyticalProvider.h"

extern NSString const *AdobeProviderCallsTrackStateForPageViewsWithProperties;

@interface AdobeProvider : ARAnalyticalProvider

- (id)initWithData:(NSDictionary *)additionalData;
- (id)initWithData:(NSDictionary *)additionalData settings:(NSDictionary*)settings;

@end
