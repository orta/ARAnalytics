#import "ARAnalyticalProvider.h"

@interface IntercomProvider : ARAnalyticalProvider

- (instancetype)initWithWithAppID:(NSString *)identifier apiKey:(NSString *)apiKey;
@property (nonatomic, assign) BOOL registerTrackedEvents;

@end
