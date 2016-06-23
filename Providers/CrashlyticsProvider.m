#import "CrashlyticsProvider.h"
#import <Crashlytics/Answers.h>

@implementation CrashlyticsProvider
#ifdef AR_CRASHLYTICS_EXISTS

- (instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([Crashlytics class], @"Crashlytics is not included");
    NSAssert([[Crashlytics class] respondsToSelector:@selector(version)], @"Crashlytics library not installed correctly.");
    [Crashlytics startWithAPIKey:identifier];

    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [[Crashlytics sharedInstance] setUserIdentifier:userID];
    }

    if (email) {
        [[Crashlytics sharedInstance] setUserEmail:email];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
    [[Crashlytics sharedInstance] setObjectValue:value forKey:property];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSString *log;
    if (properties) {
        log = [NSString stringWithFormat:@"%@%@", event, properties];
    } else {
        log = event;
    }

    [Answers logCustomEventWithName:event customAttributes:properties];

    CLSLog(@"%@", log);
}

- (void)remoteLog:(NSString *)parsedString {
    CLSLog(@"%@", parsedString);
}

- (void)error:(NSError *)error withMessage:(NSString *)message {
    [[Crashlytics sharedInstance] recordError:error withAdditionalUserInfo:@{@"message": message}];
}

#endif
@end
