//
//  OFSARSentryProvider.m
//  Pods
//
//  Created by Illia Bilov on 6/25/14.
//
//

#import "SentryProvider.h"
#import <Raven/RavenClient.h>

const NSString *OFSARSentryID = @"OFSARSentryID";

@implementation SentryProvider

- (instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([RavenClient class], @"Raven is not included");
    NSAssert([[RavenClient class] respondsToSelector:@selector(sharedClient)], @"Raven-ios library not installed correctly.");
    [RavenClient setSharedClient:[RavenClient clientWithDSN:identifier]];
    
    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    RavenClient* rc = [RavenClient sharedClient];
    NSMutableDictionary* tags = [rc.tags mutableCopy];
    tags[@"userID"] = userID;
    tags[@"userMail"] = email;
    rc.tags = tags;
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
    RavenClient* rc = [RavenClient sharedClient];
    NSMutableDictionary* extra = [rc.extra mutableCopy];
    extra[property] = value;
    rc.extra = extra;
}

@end
