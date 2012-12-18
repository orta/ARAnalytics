//
//  ARAnalytics.m
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//

#import "ARAnalytics.h"
#import "ARAnalytics+GeneratedHeader.h"

static ARAnalytics *_sharedAnalytics;

@implementation ARAnalytics {
  TestFlight *_testflight;
}

+ (void)setup {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{ _sharedAnalytics = [[ARAnalytics alloc] init]; } );
}

+ (void)setupTestFlightWithTeamToken:(NSString *)token {
    if([TestFlight class] != nil){
        [TestFlight takeOff:token];
    }
}

+ (void)event:(NSString *)event {}
+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties {}

+ (void)error:(NSString*)string, ... {}

@end
