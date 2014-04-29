//
//  ARDSL.m
//  Artsy
//
//  Created by Ash Furrow on 04/29/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARDSL.h"
#import <RSSwizzle/RSSwizzle.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString * const ARAnalyticsTrackedEvents = @"trackedEvents";
NSString * const ARAnalyticsTrackedScreens = @"trackedScreens";

NSString * const ARAnalyticsTrackedClassName = @"class";
NSString * const ARAnalyticsTrackedLabel = @"label";
NSString * const ARAnalyticsTriggeringSelector = @"selector";

Class extractClassFromDictionary (NSDictionary *dictionary) {
    NSString *className = dictionary[ARAnalyticsTrackedClassName];
    Class klass = NSClassFromString(className);
    NSCAssert(klass != Nil, @"Class cannot be nil.");
    return klass;
}

@implementation ARAnalytics (DSL)

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary {
    [self setupWithAnalytics:analyticsDictionary];
    
    NSArray *trackedScreens = configurationDictionary[ARAnalyticsTrackedScreens];
    [trackedScreens enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        Class klass = extractClassFromDictionary(object);
        
        SEL selector;
        NSString *selectorName = object[ARAnalyticsTriggeringSelector];
        if (selectorName) {
            selector = NSSelectorFromString(selectorName);
            NSAssert(selector != NULL, @"Custom selector lookup failed. ");
        } else {
            selector = @selector(viewDidAppear:);
        }
        
        NSString *label = configurationDictionary[ARAnalyticsTrackedLabel];
        
        RSSwizzleClassMethod(klass, @selector(alloc), RSSWReturnType(id), void, RSSWReplacement({
            id instance = RSSWCallOriginal();
            [[instance rac_signalForSelector:selector] subscribeNext:^(id _) {
                [ARAnalytics pageView:label];
            }];
            return instance;
        }));
    }];
    
    NSArray *trackedEvents = configurationDictionary[ARAnalyticsTrackedEvents];
    [trackedEvents enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        Class klass = extractClassFromDictionary(object);
        
        NSString *selectorName = object[ARAnalyticsTriggeringSelector];
        SEL selector = NSSelectorFromString(selectorName);
        NSAssert(selector != NULL, @"Event selector lookup failed. ");
        
        NSString *label = configurationDictionary[ARAnalyticsTrackedLabel];
        
        RSSwizzleClassMethod(klass, @selector(alloc), RSSWReturnType(id), void, RSSWReplacement({
            id instance = RSSWCallOriginal();
            [[instance rac_signalForSelector:selector] subscribeNext:^(id _) {
                //TODO: properties
                [ARAnalytics event:label withProperties:nil];
            }];
            return instance;
        }));
    }];
}

@end
