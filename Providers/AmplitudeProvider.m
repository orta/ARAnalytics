//
//  AmplitudeProvider.m
//  Pods
//
//  Created by Daniel Haight on 15/08/2013.
//
//

#import "AmplitudeProvider.h"
#import "Amplitude.h"

@implementation AmplitudeProvider
#ifdef AR_AMPLITUDE_EXISTS

-(id)initWithIdentifier:(NSString *)identifier {
    NSAssert([Amplitude class], @"Amplitude is not included");
    [Amplitude initializeApiKey:identifier];
    
    return [super init];
}

-(void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [Amplitude setUserId:@"userId"];
    }
    
    if (email) {
        [Amplitude setGlobalUserProperties:@{@"email": email}];
    }
}

-(void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [Amplitude logEvent:event withCustomProperties:properties];
}

-(void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [Amplitude setGlobalUserProperties:@{property: value}];
}

#endif
@end
