//
//  LocalyticsProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "LocalyticsProvider.h"
#import "LocalyticsSession.h"

@implementation LocalyticsProvider
#ifdef AR_LOCALYTICS_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([LocalyticsSession class], @"Localytics is not included");
    [[LocalyticsSession sharedLocalyticsSession] startSession:identifier];

    return [super init];
}

- (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
    [[LocalyticsSession sharedLocalyticsSession] setCustomerName:id];
    if (email) {
        [[LocalyticsSession sharedLocalyticsSession] setCustomerEmail:email];
    }
}

-(void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    // This is for enterprise only...
    [[LocalyticsSession sharedLocalyticsSession] setValueForIdentifier:property value:value];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:event attributes:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    // This is for enterprise only...
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:pageTitle];
}

#endif
@end
