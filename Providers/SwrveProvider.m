//
//  SegmentioProvider.m
//

#import "SwrveProvider.h"
#import "ARAnalyticsProviders.h"
#import "Swrve.h"

@implementation SwrveProvider

#ifdef AR_SWRVE_EXISTS
- (id)initWithAppID:(NSString *)appID apiKey:(NSString *)apiKey {
    [Swrve sharedInstanceWithAppID:appID.intValue apiKey:apiKey];
    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (!userID && !email) return;
    
    NSMutableDictionary *traits = NSMutableDictionary.dictionary;
    if (userID) traits[@"id"] = userID;
    if (email) traits[@"email"] = email;
    [Swrve.sharedInstance userUpdate:traits];
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    if (!property) return;
    
    NSDictionary *traits = @{ property: value ?: NSNull.null };
    [Swrve.sharedInstance userUpdate:traits];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [Swrve.sharedInstance event:event payload:properties];
}

#endif
@end
