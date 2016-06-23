#import "MixpanelProvider.h"
#import "ARAnalyticsProviders.h"
#import "Mixpanel.h"

static NSString * const kMixpanelTimingPropertyKey = @"$duration";

@interface MixpanelProvider()
    @property (nonatomic, readonly) Mixpanel *mixpanel;
@end

@implementation MixpanelProvider

- (instancetype)initWithIdentifier:(NSString *)identifier {
    return [self initWithIdentifier:identifier andHost:nil];
}

- (instancetype)initWithIdentifier:(NSString *)identifier andHost:(NSString *)host {
#ifdef AR_MIXPANEL_EXISTS

    NSAssert([Mixpanel class], @"Mixpanel is not included");

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mixpanel = [Mixpanel sharedInstanceWithToken:identifier];
    });

    if(! _mixpanel) {
        _mixpanel = [[Mixpanel alloc] initWithToken:identifier andFlushInterval:60];
    }

    if (host) {
        _mixpanel.serverURL = host;
    }
#endif
    return [super init];
}

#ifdef AR_MIXPANEL_EXISTS
- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [self.mixpanel identify:userID];
    }

    if (email) {
        [[self.mixpanel people] set:@"$email" to:email];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
    [[self.mixpanel people] set:property to:value];
}

- (void)incrementUserProperty:(NSString *)counterName byInt:(NSNumber *)amount {
    [[self.mixpanel people] increment:counterName by:amount];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [self.mixpanel track:event properties:properties];
}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval properties:(NSDictionary *)properties {
    
    if (properties[kMixpanelTimingPropertyKey]) {
        NSString *warning = [NSString stringWithFormat:@"Properties for timing event '%@' contains a key that clashes with the key used for reporting the time: %@", event, kMixpanelTimingPropertyKey];
        NSLog(@"%@", warning);
        NSAssert(properties[kMixpanelTimingPropertyKey], @"%@", warning);
    }
    
    NSMutableDictionary *mutableProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
    if (interval) {
        mutableProperties[kMixpanelTimingPropertyKey] = interval;
    }
    
    [self event:event withProperties:mutableProperties];
}

- (void)createAlias:(NSString *)alias
{
    [self.mixpanel createAlias:alias forDistinctID:self.mixpanel.distinctId];
    [self identifyUserWithID:alias andEmailAddress:nil];
}

- (void)registerSuperProperties:(NSDictionary *)properties
{
    [self.mixpanel registerSuperProperties:properties];
}

- (void)addPushDeviceToken:(NSData *)deviceToken
{
    [[self.mixpanel people] addPushDeviceToken:deviceToken];
}

- (NSDictionary *)currentSuperProperties
{
    return [self.mixpanel currentSuperProperties];
}

- (void)reset
{
    [self.mixpanel reset];
}

#endif
@end
