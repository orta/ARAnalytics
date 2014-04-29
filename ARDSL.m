//
//  ARDSL.m
//  Artsy
//
//  Created by Ash Furrow on 04/29/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARDSL.h"
#import <RSSwizzle/RSSwizzle.h>

NSString * const ARAnalyticsTrackedEvents = @"trackedEvents";
NSString * const ARAnalyticsTrackedScreens = @"trackedScreens";

NSString * const ARAnalyticsTrackedClass = @"class";
NSString * const ARAnalyticsTrackedLabel = @"label";

@implementation ARAnalytics (DSL)

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary {
    [self setupWithAnalytics:analyticsDictionary];
    
    NSArray *trackedScreens = configurationDictionary[ARAnalyticsTrackedScreens];
    [trackedScreens enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        NSString *className = object[ARAnalyticsTrackedClassName];
        Class klass = NSClassFromString(className);
        
        NSString *label = configurationDictionary[ARAnalyticsTrackedLabel];
        
        RSSwizzleInstanceMethod(klass,
                                @selector(viewDidLoad:),
                                RSSWReturnType(void),
                                RSSWArguments(BOOL animated),
                                RSSWReplacement(
        {
            // The following code will be used as the new implementation.
            
            [self pageView:label];
            
            // Calling original implementation.
            RSSWCallOriginal(animated);
        }), 0, NULL);
    }];
}

@end
