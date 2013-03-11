//
//  CrittercismProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "CrittercismProvider.h"
#import "ARAnalyticsProviders.h"

@implementation CrittercismProvider
#ifdef AR_CRITTERCISM_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([Crittercism class], @"Crittercism is not included");
    [Crittercism enableWithAppID:identifier];

    return [super init];
}

- (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
    [Crittercism setUsername:id];
    if (email) {
        [Crittercism setEmail:email];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [Crittercism setValue:value forKey:property];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [Crittercism leaveBreadcrumb:event];
}

- (void)didShowNewViewController:(UIViewController *)controller {
    NSString *string = [NSString stringWithFormat:@"Opened %@", controller.title];
    [Crittercism leaveBreadcrumb: string];
}

- (void)remoteLog:(NSString *)parsedString {
    [Crittercism leaveBreadcrumb:parsedString];
}

#endif
@end
