//
//  CrittercismProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "CrittercismProvider.h"
#import "Crittercism.h"

@implementation CrittercismProvider
#ifdef AR_CRITTERCISM_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([Crittercism class], @"Crittercism is not included");
    [Crittercism enableWithAppID:identifier];

    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [Crittercism setUsername:userID];
    }

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

- (void)didShowNewPageView:(NSString *)pageTitle {
    NSString *string = [NSString stringWithFormat:@"Opened %@", pageTitle];
    [Crittercism leaveBreadcrumb: string];
}

- (void)remoteLog:(NSString *)parsedString {
    [Crittercism leaveBreadcrumb:parsedString];
}

#endif
@end
