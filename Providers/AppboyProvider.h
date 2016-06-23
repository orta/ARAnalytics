#import "ARAnalyticalProvider.h"

/**
 * Use this provider to track events to Appboy.
 * 
 * NOTE: You still need to setup Appboy in your AppDelegate (needs application and launchOptions)!
 *		 Use [Appboy startWithApiKey:@"YOUR-API-KEY" inApplication:application withLaunchOptions:launchOptions]; for this.
*/
@interface AppboyProvider : ARAnalyticalProvider

@end
