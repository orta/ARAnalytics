#import "ARAnalyticalProvider.h"
#import "TSTapstream.h"

@interface TapstreamProvider : ARAnalyticalProvider

- (instancetype)initWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret;
- (instancetype)initWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret config:(TSConfig *)config;

@end
