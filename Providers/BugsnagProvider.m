//
//  BugsnagProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 19/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "BugsnagProvider.h"

@implementation BugsnagProvider
#ifdef AR_BUGSNAP_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([Bugsnap class], @"Bugspan is not included");
    [Bugsnap startBugsnagWithApiKey:identifier];

    return [super init];
}

- (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
    [Bugsnap instance].userId = id;
    [Bugsnap setUserAttribute:@"email" withValue:email];
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [Bugsnap setUserAttribute:property withValue:value];
}

#endif
@end
