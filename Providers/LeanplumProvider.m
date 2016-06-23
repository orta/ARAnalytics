#import "LeanplumProvider.h"
#import "ARAnalyticsProviders.h"
#import <Leanplum/Leanplum.h>

@implementation LeanplumProvider
#ifdef AR_LEANPLUM_EXISTS

- (instancetype)initWithAppId:(NSString *)appId developmentKey:(NSString *)developmentKey productionKey:(NSString *)productionKey
{
    if (self = [super init]) {

        if (productionKey) {
            [Leanplum setAppId:appId withProductionKey:productionKey];
        }
        else {
            LEANPLUM_USE_ADVERTISING_ID;
            [Leanplum setAppId:appId withDevelopmentKey:developmentKey];
        }
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [Leanplum start];
    });
    return self;
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [Leanplum setUserId:userID];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [Leanplum track:event withParameters:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [self didShowNewPageView:pageTitle withProperties:nil];
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {

    // We are tracking pageViews as events
    [self event:pageTitle withProperties:properties];
}

#endif

@end
