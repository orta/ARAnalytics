#import "ARAnalyticalProvider.h"

@interface LeanplumProvider : ARAnalyticalProvider

- (instancetype)initWithIdentifier:(NSString *)identifier NS_UNAVAILABLE;

/**
 * Initializes an instance of LeanplumProvider with the given parameters.
 * 
 * NOTE: developmentKey XOR productionKey has to be set!
*/
- (instancetype)initWithAppId:(NSString *)appId developmentKey:(NSString *)developmentKey productionKey:(NSString *)productionKey;

@end
