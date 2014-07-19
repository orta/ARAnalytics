//
//  ARAnalyticalProvider.h
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestFlightProvider.h"
#import "TestFlight.h"
#import "BPXLUUIDHandler.h"

@implementation TestFlightProvider
#ifdef AR_TESTFLIGHT_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([TestFlight class], @"TestFlight is not included");
    
    [TestFlight takeOff:identifier];

    return [super init];
}

+ (NSString *)uniqueID {
    // iOS 6 has a good API for getting a unique ID
    if ([UICollectionView class] != nil) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }

    return [BPXLUUIDHandler UUID];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [TestFlight addCustomEnvironmentInformation:userID forKey:@"user_id"];
    }
    
    if (email) {
        [TestFlight addCustomEnvironmentInformation:email forKey:@"email"];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {
    [TestFlight addCustomEnvironmentInformation:value forKey:property];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSString *checkpoint;
    
    if (properties) {
        checkpoint = [NSString stringWithFormat:@"%@%@", event, properties];
    } else {
        checkpoint = event;
    }
    
    [TestFlight passCheckpoint:checkpoint];
}

- (void)remoteLog:(NSString *)parsedString {
    TFLogPreFormatted(parsedString);
}

#endif
@end

