#import "ARAnalyticalProvider.h"

@interface MixpanelProvider : ARAnalyticalProvider
- (id)initWithIdentifier:(NSString *)identifier andHost:(NSString *)host;
- (void)createAlias:(NSString *)alias;
@end
