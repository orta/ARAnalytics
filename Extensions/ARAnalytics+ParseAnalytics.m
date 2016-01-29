//
//  ARAnalytics+ParseAnalytics.m
//  ARAnalytics
//
//  Created by Dmitry Obukhov on 26/08/15.
//  Copyright (c) 2015 Wirelessheads. All rights reserved.
//

#import "ARAnalytics+ParseAnalytics.h"
#import <Parse/Parse.h>

@implementation ARAnalytics (ParseAnalytics)

+ (void)trackAppOpenedWithLaunchOptions:(NSDictionary *)launchOptions {
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

@end
