//
//  SegmentioProvider.m
//

#import "SwrveProvider.h"
#import "ARAnalyticsProviders.h"
#import "Swrve.h"

@implementation SwrveProvider

#ifdef AR_SWRVE_EXISTS
- (instancetype)initWithAppID:(NSString *)appID apiKey:(NSString *)apiKey {
    [Swrve sharedInstanceWithAppID:appID.intValue apiKey:apiKey];
    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (!userID) return;
    
    NSDictionary *traits = email ? @{ @"id": userID, @"email": email } : @{ @"id": userID };
    [Swrve.sharedInstance userUpdate:traits];
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
    if (!property) return;
    
    NSDictionary *traits = @{ property: value ?: NSNull.null };
    [Swrve.sharedInstance userUpdate:traits];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [Swrve.sharedInstance event:event payload:properties];
}

#endif
@end
