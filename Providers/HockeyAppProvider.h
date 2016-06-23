#import "ARAnalyticalProvider.h"

@interface HockeyAppProvider : ARAnalyticalProvider
-(instancetype)initWithBetaIdentifier:(NSString *)betaIdentifier liveIdentifier:(NSString *)liveIdentfier;
@end
