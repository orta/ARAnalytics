#import <MobileAppTracker/Tune.h>
#import <MobileAppTracker/TuneEvent.h>
#import "ARAnalyticsProviders.h"

@import AdSupport.ASIdentifierManager;

@implementation MobileAppTrackerProvider
#ifdef AR_MOBILEAPPTRACKER_EXISTS

#pragma mark - Lifecyle

- (instancetype)initWithAdvertiserId:(NSString *)advertiserId
                       conversionKey:(NSString *)conversionKey
                       allowedEvents:(NSArray *)allowedEvents {
    
    NSAssert([Tune class], @"MobileAppTracker/Tune is not included");
    
    self = [super init];
    
    if (self) {
    
        [Tune initializeWithTuneAdvertiserId:advertiserId tuneConversionKey:conversionKey];
        [Tune setAppleAdvertisingIdentifier:[[ASIdentifierManager sharedManager] advertisingIdentifier]
                 advertisingTrackingEnabled:[[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]];
        
        self.allowedEvents = allowedEvents;
        [self registerNotifications];
    }
    
    return self;
}

- (void)dealloc {

    [self unregisterNotifications];
}

#pragma mark - Overwrites

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    
    if ([self.allowedEvents containsObject:event]) {
    
        TuneEvent *tuneEvent = [TuneEvent eventWithName:event];
        [Tune measureEvent:tuneEvent];
    }
}

#pragma mark - Notifications

- (void)registerNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)unregisterNotifications {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {

    [Tune measureSession];
}

#endif
@end
