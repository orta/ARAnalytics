#import "AppboyProvider.h"
#import "ARAnalyticsProviders.h"
#import <Appboy-iOS-SDK/AppboyKit.h>

@implementation AppboyProvider
#ifdef AR_APPBOY_EXISTS

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    NSAssert([Appboy sharedInstance], @"You need to call [Appboy startWithApiKey:inApplication:withLaunchOptions:] before setting the user id!");
    [[Appboy sharedInstance] changeUser:userID];
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {

    NSAssert([Appboy sharedInstance], @"You need to call [Appboy startWithApiKey:inApplication:withLaunchOptions:] before setting user properties!");

    if ([value isKindOfClass:[NSString class]]) {
        [[Appboy sharedInstance].user setCustomAttributeWithKey:property andStringValue:value];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        [[Appboy sharedInstance].user setCustomAttributeWithKey:property andDoubleValue:[value doubleValue]];
    }
    else if ([value isKindOfClass:[NSDate class]]) {
        [[Appboy sharedInstance].user setCustomAttributeWithKey:property andDateValue:value];
    }
    else {
        NSLog(@"Appboy is not able to track user properties that are not strings, numbers or dates.");
    }
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSAssert([Appboy sharedInstance], @"You need to call [Appboy startWithApiKey:inApplication:withLaunchOptions:] before setting user properties!");
    [[Appboy sharedInstance] logCustomEvent:event withProperties:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [self didShowNewPageView:pageTitle withProperties:nil];
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {

    // Appboy does not use pageViews, so a pageView is just another custom event
    [self event:pageTitle withProperties:properties];
}

- (void)incrementUserProperty:(NSString *)counterName byInt:(NSNumber *)amount {

    [[Appboy sharedInstance].user incrementCustomUserAttribute:counterName by:amount.integerValue];
}

#endif

@end
