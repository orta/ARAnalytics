#import "AppsFlyerProvider.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>

const NSString * ARAppsFlyerEventPropertyCurrencyCode = @"currencyCode";
const NSString * ARAppsFlyerEventPropertyValue = @"value";

@implementation AppsFlyerProvider
#ifdef AR_APPSFLYER_EXISTS

- (instancetype)initWithIdentifier:(NSString *)identifier {
    NSLog(@"Use -[AppsFlyerProvider initWithAppID:devKey:] instead of %s", __PRETTY_FUNCTION__);
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithAppID:(NSString *)appID devKey:(NSString *)devKey {
    self = [super init];
    if (!self) return nil;

    AppsFlyerTracker.sharedTracker.appsFlyerDevKey = devKey;
    AppsFlyerTracker.sharedTracker.appleAppID = appID;

    [AppsFlyerTracker.sharedTracker trackAppLaunch];

    return self;
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        AppsFlyerTracker.sharedTracker.customerUserID = userID;
    }
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSString *currencyCode = properties[ARAppsFlyerEventPropertyCurrencyCode];
    if (currencyCode) {
        AppsFlyerTracker.sharedTracker.currencyCode = currencyCode;
    }

    if (event) {
        NSString *value = properties[ARAppsFlyerEventPropertyValue] ?: @"";
        [AppsFlyerTracker.sharedTracker trackEvent:event withValue:value];
    }
}

#endif
@end
