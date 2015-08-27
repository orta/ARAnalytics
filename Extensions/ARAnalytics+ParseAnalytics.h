//
//  ARAnalytics+ParseAnalytics.h
//  ARAnalytics
//
//  Created by Dmitry Obukhov on 26/08/15.
//  Copyright (c) 2015 Wirelessheads. All rights reserved.
//

#import "ARAnalytics.h"

@interface ARAnalytics (ParseAnalytics)

+ (void)trackAppOpenedWithLaunchOptions:(NSDictionary *)launchOptions;

@end
