//
//  ARAnalyticalProvider.h
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARAnalyticalProvider.h"

static NSString *const ARTimingEventLengthKey = @"length";

@implementation ARAnalyticalProvider

- (id)initWithIdentifier:(NSString *)identifier {
    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {}
- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {}
- (void)incrementUserProperty:(NSString *)counterName byInt:(NSNumber *)amount {}

- (void)error:(NSError *)error withMessage:(NSString *)message {
	NSAssert(error, @"NSError instance has to be supplied");
	if(!message){
	   message = (error.localizedFailureReason) ? error.localizedFailureReason : @"Error";
	}
	
	NSString *empty = @"(empty)";
	[self event:message withProperties:@{
		@"failureReason" : (error.localizedFailureReason) ? error.localizedFailureReason : empty,
		@"description" : (error.localizedDescription) ? error.localizedDescription : empty,
		@"recoverySuggestion" : (error.localizedRecoverySuggestion) ? error.localizedRecoverySuggestion : empty,
		@"recoveryOptions" : ([error.localizedRecoveryOptions isKindOfClass:NSArray.class]) ? [error.localizedRecoveryOptions componentsJoinedByString:@", "] : empty
	}];
}

- (void)monitorNavigationViewController:(UINavigationController *)controller {}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval {
    [self logTimingEvent:event withInterval:interval properties:nil];
}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval properties:(NSDictionary *)properties {
    
    if (properties[ARTimingEventLengthKey]) {
        NSString *warning = [NSString stringWithFormat:@"Properties for timing event '%@' contains a key that clashes with the key used for reporting the length: %@", event, ARTimingEventLengthKey];
        NSLog(@"%@", warning);
        NSAssert(properties[ARTimingEventLengthKey], @"%@", warning);
    }
    
    NSMutableDictionary *mutableProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
    mutableProperties[ARTimingEventLengthKey] = interval;
    
    [self event:event withProperties:mutableProperties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [self event:@"Screen view" withProperties:@{ @"screen": pageTitle }];
}

- (void)remoteLog:(NSString *)parsedString {}

@end
