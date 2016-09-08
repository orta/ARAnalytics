#import "IntercomProvider.h"
#import "ARAnalyticsProviders.h"
#import <Intercom/Intercom.h>

@implementation IntercomProvider

- (instancetype)initWithWithAppID:(NSString *)identifier apiKey:(NSString *)apiKey
{
    NSAssert([Intercom class], @"Intercom is not included");

    [Intercom setApiKey:apiKey forAppId:identifier];
    _registerTrackedEvents = YES;

    return [super init];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties
{
    // Use ARAnalytics providerInstanceOfClass:IntercomProvider
    // to turn this off if you're getting too many events

    if (!self.registerTrackedEvents) {
        return;
    }

    if (properties && properties.count > 0) {
        [Intercom logEventWithName:event metaData:properties];
    } else {
        [Intercom logEventWithName:event];
    }
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email
{
    [Intercom reset];
    
    if (email) {
        [Intercom registerUserWithUserId:userID email:email];
    } else if (userID) {
        [Intercom registerUserWithUserId:userID];
    } else {
        [Intercom registerUnidentifiedUser];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(id)value
{
    [Intercom updateUserWithAttributes:@{ @"custom_attributes": @{ property: value }}];
}

@end
