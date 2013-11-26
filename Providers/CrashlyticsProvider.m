//
//  CrashlyticsProvider.m
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "CrashlyticsProvider.h"

@implementation CrashlyticsProvider
#ifdef AR_CRASHLYTICS_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([Crashlytics class], @"Crashlytics is not included");
    NSAssert([[Crashlytics class] respondsToSelector:@selector(version)], @"Crashlytics library not installed correctly.");
    [Crashlytics startWithAPIKey:identifier];

    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [Crashlytics setUserIdentifier:userID];
    }

    if (email) {
        [Crashlytics setUserEmail:email];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [Crashlytics setObjectValue:value forKey:property];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSString *log;
    if (properties) {
        log = [NSString stringWithFormat:@"%@%@", event, properties];
    } else {
        log = event;
    }
    
    CLSLog(@"%@", log);
}

- (void)remoteLog:(NSString *)parsedString {
    CLSLog(@"%@", parsedString);
}

#endif
@end
