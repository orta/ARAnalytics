#import "ARAnalyticalProvider.h"

extern const NSString * ARAppsFlyerEventPropertyCurrencyCode;
extern const NSString * ARAppsFlyerEventPropertyValue;

/**
 When using AppsFlyer, you'll need to tell Apple you use the IDFA,
 per <http://support.appsflyer.com/entries/52460386-New-Apple-IDFA-Guidelines-How-To-Submit-Your-iOS-App-With-IDFA>
 */
@interface AppsFlyerProvider : ARAnalyticalProvider

- (instancetype)initWithAppID:(NSString *)appID devKey:(NSString *)devKey;

@end
