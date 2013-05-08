//
//  MixpanelProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "MixpanelProvider.h"
#import "ARAnalyticsProviders.h"
#import "Mixpanel.h"

@implementation MixpanelProvider

- (id)initWithIdentifier:(NSString *)identifier {
    return [self initWithIdentifier:identifier andHost:nil];
}

- (id)initWithIdentifier:(NSString *)identifier andHost:(NSString *)host {
#ifdef AR_MIXPANEL_EXISTS

    NSAssert([Mixpanel class], @"Mixpanel is not included");
    [Mixpanel sharedInstanceWithToken:identifier];

    if (host) {
        [[Mixpanel sharedInstance] setServerURL:host];
    }
#endif
    return [super init];
}

#ifdef AR_MIXPANEL_EXISTS
- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [[Mixpanel sharedInstance] identify:userID];
    }

    if (email) {
        [[[Mixpanel sharedInstance] people] set:@"$email" to:email];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [[[Mixpanel sharedInstance] people] set:property to:value];
}

- (void)incrementUserProperty:(NSString *)counterName byInt:(NSNumber *)amount {
    [[[Mixpanel sharedInstance] people] increment:counterName by:amount];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[Mixpanel sharedInstance] track:event properties:properties];
}

#endif
@end
