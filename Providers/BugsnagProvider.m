//
//  BugsnagProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 19/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "BugsnagProvider.h"
#import "Bugsnag.h"

@implementation BugsnagProvider
#ifdef AR_BUGSNAP_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([Bugsnag class], @"Bugsnag is not included");
    [Bugsnag startBugsnagWithApiKey:identifier];

    return [super init];
}

- (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {
    [Bugsnag instance].userId = id;
    [Bugsnag setUserAttribute:@"email" withValue:email];
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [Bugsnag setUserAttribute:property withValue:value];
}

#endif
@end
