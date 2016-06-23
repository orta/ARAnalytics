//
//  BranchProvider.m
//

#import "BranchProvider.h"
#import "ARAnalyticsProviders.h"
#import "Branch.h"

@implementation BranchProvider

#ifdef AR_BRANCH_EXISTS
- (instancetype)initWithAPIKey:(NSString *)key {
    NSAssert([Branch class], @"Branch is not included");
    [Branch getInstance:key];
    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (!userID) return;
    [[Branch getInstance] setIdentity:userID]; // Branch only takes a user id string, no email
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    if (!event) return;
    if (properties) {
        [[Branch getInstance] userCompletedAction:event withState:properties];
    } else {
        [[Branch getInstance] userCompletedAction:event];
    }
}

- (void)incrementUserProperty:(NSString *)counterName byInt:(NSNumber *)amount {
    if (!counterName || !amount) return;
    if ([counterName isEqualToString:@"redeem"]) {
        [[Branch getInstance] redeemRewards:[amount intValue]];
    }
}

#endif
@end
