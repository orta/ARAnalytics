#import "FirebaseProvider.h"
#import "ARAnalyticsProviders.h"
#import <Firebase/Firebase.h>

@implementation FirebaseProvider
#ifdef AR_FIREBASE_EXISTS

- (instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([FIRApp class], @"Firebase SDK is not included");
    NSAssert([FIRAnalytics class], @"Firebase SDK is not included");

    if ((self = [super init])) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [FIRApp configure];
        });
    }

    return self;
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [FIRAnalytics setUserID:userID];
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {

    if (![value isKindOfClass:[NSString class]])
    {
        NSLog(@"Tried to log user property %@ for property name %@, but value is no NSString. Only NSString values are supported by Firebase Analytics.", value, property);
        return;
    }

    NSString *stringValue = ((NSString *)value);
    [FIRAnalytics setUserPropertyString:stringValue forName:property];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [FIRAnalytics logEventWithName:event parameters:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [self didShowNewPageView:pageTitle withProperties:nil];
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {

    // Firebase Analytics does not offer a functionality for page views, so they are tracked as events
    [self event:pageTitle withProperties:properties];
}

#endif

@end
