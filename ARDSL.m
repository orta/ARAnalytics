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
NSString * const ARAnalyticsTriggeringSelector = @"selector";

@implementation ARAnalytics (DSL)

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary {
    [self setupWithAnalytics:analyticsDictionary];
    
    NSArray *trackedScreens = configurationDictionary[ARAnalyticsTrackedScreens];
    [trackedScreens enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        NSString *className = object[ARAnalyticsTrackedClassName];
        Class klass = NSClassFromString(className);
        NSAssert(klass != Nil, @"Class cannot be nil.");
        
        SEL selector;
        NSString *selectorName = object[ARAnalyticsTriggeringSelector];
        if (selectorName) {
            selector = NSSelectorFromString(selectorName);
            NSAssert(selector != NULL, @"Custom selector lookup failed. ");
        } else {
            selector = @selector(viewDidAppear:);
        }
        
        NSString *label = configurationDictionary[ARAnalyticsTrackedLabel];
        
        RSSwizzleInstanceMethod(klass,
                                selector,
                                RSSWReturnType(void),
                                RSSWArguments(BOOL animated),
                                RSSWReplacement(
        {
            [self pageView:label];
            
            // Calling original implementation.
            RSSWCallOriginal(animated);
        }), 0, NULL);
    }];
}

@end
