#import "KeenProvider.h"
#import "KeenClient.h"

#import <Foundation/Foundation.h>

static NSString * const kKeenUserIDKey = @"user_id";
static NSString * const kKeenEmailKey = @"email";

@implementation KeenProvider

- (instancetype)initWithProjectID:(NSString *)projectID andWriteKey:(NSString *)writeKey andReadKey:(NSString *)readKey {
#ifdef AR_KEEN_EXISTS
    NSAssert([KeenClient class], @"Keen Client is not included");
    [KeenClient sharedClientWithProjectID:projectID andWriteKey:writeKey andReadKey:readKey];
#endif
    return [super init];
}

#ifdef AR_KEEN_EXISTS

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties
{
    [[KeenClient sharedClient] addEvent:properties toEventCollection:event error:nil];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email
{
    [self setUserProperty:kKeenUserIDKey toValue:userID];
    [self setUserProperty:kKeenEmailKey toValue:email];
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
{
    KeenClient *client = [KeenClient sharedClient];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:client.globalPropertiesDictionary];

    if (value) {
        [dict setObject:value forKey:property];
    } else {
        [dict removeObjectForKey:property];
    }
    client.globalPropertiesDictionary = [dict copy];
}

// Additional implementation overrides, based on ARAnalyticalProvider, should follow here.

#endif

@end
