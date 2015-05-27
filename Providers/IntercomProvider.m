#import "IntercomProvider.h"
#import "ARAnalyticsProviders.h"
#import <Intercom/Intercom.h>

@implementation IntercomProvider

- (instancetype)initWithWithAppID:(NSString *)identifier apiKey:(NSString *)apiKey
{
    NSAssert([Intercom class], @"Intercom is not included");

    [Intercom setApiKey:apiKey forAppId:identifier];

    return [super init];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties
{
    [Intercom logEventWithName:event metaData:properties];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email
{
    if (email) {
        [Intercom registerUserWithUserId:userID email:email];
    } else {
        [Intercom registerUserWithUserId:userID];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value
{
    [Intercom updateUserWithAttributes:@{ @"custom_attributes": @{ property: value }}];
}

@end
