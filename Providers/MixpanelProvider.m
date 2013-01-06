//
//  MixpanelProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "MixpanelProvider.h"

@implementation MixpanelProvider

#ifdef AR_MIXPANEL_EXISTS
- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([Mixpanel class], @"Mixpanel is not included");
    [Mixpanel sharedInstanceWithToken:identifier];

    self = [super init];
    return self;
}

- (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
    [[[Mixpanel sharedInstance] people] identify:id];
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

- (void)didShowNewViewController:(UIViewController *)controller {
    [self event:@"Screen view" withProperties:@{ @"screen": controller.title }];
}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval {
    [self event:event withProperties:@{ @"length": interval }];
}

#endif
@end
