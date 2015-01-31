#import "LocalyticsProvider.h"

#ifdef AR_LOCALYTICS_EXISTS
#import "LocalyticsSession.h"
#endif
@interface LocalyticsProvider ()

- (void) startLocalytics;
- (void) stopLocalytics;

@end

@implementation LocalyticsProvider
#ifdef AR_LOCALYTICS_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([LocalyticsSession class], @"Localytics is not included");

    if( ( self = [super init] ) ) {
        
        [[LocalyticsSession sharedLocalyticsSession] LocalyticsSession:identifier];
        
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
    }

    return self;
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [[LocalyticsSession sharedLocalyticsSession] setCustomerId:userID];
    }

    if (email) {
        [[LocalyticsSession sharedLocalyticsSession] setCustomerEmail:email];
    }
}

-(void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [[LocalyticsSession sharedLocalyticsSession] setValueForIdentifier:property value:value];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:event attributes:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:pageTitle];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Localytics events

- (void)startLocalytics {
    [[LocalyticsSession sharedLocalyticsSession] open];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)stopLocalytics {
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

#endif
@end
