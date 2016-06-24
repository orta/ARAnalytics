#import "LocalyticsProvider.h"

#ifdef AR_LOCALYTICS_EXISTS
#import <Localytics/Localytics.h>
#endif
@interface LocalyticsProvider ()

- (void) startLocalytics;
- (void) stopLocalytics;

@end

@implementation LocalyticsProvider
#ifdef AR_LOCALYTICS_EXISTS

- (instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([Localytics class], @"Localytics is not included");

    if( ( self = [super init] ) ) {
        
        [Localytics integrate:identifier];
        
        for( NSString *activeEvent in @[ UIApplicationDidBecomeActiveNotification, 
                                         UIApplicationWillEnterForegroundNotification ]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(startLocalytics)
                                                         name:activeEvent
                                                       object:nil];
        }

        for( NSString *inactiveEvent in @[ UIApplicationWillResignActiveNotification,
                                           UIApplicationWillTerminateNotification,
                                           UIApplicationDidEnterBackgroundNotification ]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(stopLocalytics)
                                                         name:inactiveEvent
                                                       object:nil];
        }
        
        [Localytics openSession];
    }

    return self;
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [Localytics setCustomerId:userID];
    }

    if (email) {
        [Localytics setCustomerEmail:email];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
    [Localytics setValue:value forIdentifier:property];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [Localytics tagEvent:event attributes:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {
    [Localytics tagScreen:pageTitle];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Localytics events

- (void)startLocalytics {
    [Localytics openSession];
    [Localytics upload];
}

- (void)stopLocalytics {
    [Localytics closeSession];
    [Localytics upload];
}

#endif
@end
