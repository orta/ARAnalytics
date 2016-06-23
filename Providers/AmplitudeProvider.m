#import "AmplitudeProvider.h"
#import "Amplitude.h"

@implementation AmplitudeProvider
#ifdef AR_AMPLITUDE_EXISTS

-(instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([Amplitude class], @"Amplitude is not included");
    [[Amplitude instance] initializeApiKey:identifier];
    
    return [super init];
}

-(void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [[Amplitude instance] setUserId:userID];
    }
    
    if (email) {
        [[Amplitude instance] setUserId:email];
    }
}

-(void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[Amplitude instance] logEvent:event withEventProperties:properties];
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
    [[Amplitude instance] setUserProperties:@{property: value}];
}

#endif
@end
