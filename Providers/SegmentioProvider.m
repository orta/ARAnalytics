//
//  SegmentioProvider.m
//

#import "SegmentioProvider.h"
#import "ARAnalyticsProviders.h"
#import "SEGAnalytics.h"

#ifdef AR_SEGMENTIO_EXISTS
@interface SegmentioProvider ()
@property (assign) BOOL hasIdentified;
@property (copy) NSString *userID;
@property (copy) NSString *anonymousID;
@property (copy) NSDictionary *traits;
@end
#endif

@implementation SegmentioProvider

#ifdef AR_SEGMENTIO_EXISTS
- (instancetype)initWithIdentifier:(NSString *)identifier {
	return [self initWithIdentifier:identifier integrations:nil];
}
- (instancetype)initWithIdentifier:(NSString *)identifier integrations:(NSArray *)integrations {
    if ((self = [super initWithIdentifier:identifier])) {
		SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:identifier];
		for (id integration in integrations) {
			[config use:integration];
		}
        [SEGAnalytics setupWithConfiguration:config];
        _traits = @{};
    }
    return self;
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [self identifyUserWithID:userID anonymousID:nil andEmailAddress:email];
}

- (void)identifyUserWithID:(NSString *)userID anonymousID:(NSString *)anonymousID andEmailAddress:(NSString *)email {
    self.userID = userID;
    self.anonymousID = anonymousID;
    if (email) {
        [self _setUserProperty:@"email" toValue:email];
    }
    [self _identify];
}

- (void)_identify {
    NSDictionary *options = self.anonymousID == nil ? nil : @{ @"anonymousId": self.anonymousID };
    [[SEGAnalytics sharedAnalytics] identify:self.userID traits:self.traits options:options];
    self.hasIdentified = YES;
}

// This will only call -identify if the user has identified before. This makes it possible to first set multiple
// properties without making multiple identify requests.
- (void)setUserProperty:(NSString *)property toValue:(id)value {
    [self _setUserProperty:property toValue:value];
    if (self.hasIdentified) {
#ifdef DEBUG
        NSLog(@"Calling -[SegmentioProvider setUserProperty:toValue:] after identifying will perform an identity request for each call.");
#endif
        [self _identify];
    }
}

- (void)_setUserProperty:(NSString *)property toValue:(id)value {
    NSMutableDictionary *traits = [self.traits mutableCopy];
    if (value) {
        traits[property] = value;
    } else {
        [traits removeObjectForKey:property];
    }
    self.traits = traits;
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[SEGAnalytics sharedAnalytics] track:event properties:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [[SEGAnalytics sharedAnalytics] screen:pageTitle];
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {
    [[SEGAnalytics sharedAnalytics] screen:pageTitle properties:properties];
}

#endif
@end
