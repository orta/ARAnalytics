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

NSString * const ARAnalyticsClass = @"class";
NSString * const ARAnalyticsPageName = @"pageName";
NSString * const ARAnalyticsPageNameKeyPath = @"keypath";
NSString * const ARAnalyticsEventName = @"event";
NSString * const ARAnalyticsSelectorName = @"selector";
NSString * const ARAnalyticsEventProperties = @"properties";
NSString * const ARAnalyticsShouldFire = @"shouldFire";;

Class extractClassFromDictionary (NSDictionary *dictionary) {
    Class klass = dictionary[ARAnalyticsClass];
    NSCAssert(klass != Nil, @"Class cannot be nil.");
    return klass;
}

BOOL shouldFireForInstance (NSDictionary *dictionary, id instance, RACTuple *context) {
    ARAnalyticsEventShouldFireBlock shouldFireBlock = dictionary[ARAnalyticsShouldFire];
    
    BOOL shouldFire;
    if (shouldFireBlock) {
        shouldFire = shouldFireBlock(instance, context);
    } else {
        shouldFire = YES;
    }
    
    return shouldFire;
}

@implementation ARAnalytics (DSL)

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary {
    [self setupWithAnalytics:analyticsDictionary];
    
    NSArray *trackedScreens = configurationDictionary[ARAnalyticsTrackedScreens];
    [trackedScreens enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        Class klass = extractClassFromDictionary(object);
        
        SEL selector;
        NSString *selectorName = object[ARAnalyticsSelectorName];
        if (selectorName) {
            selector = NSSelectorFromString(selectorName);
            NSAssert(selector != NULL, @"Custom selector lookup failed. ");
        } else {
#if TARGET_OS_IPHONE
            selector = @selector(viewDidAppear:);
            NSAssert([[klass new] isKindOfClass:[UIViewController class]], @"Default selector of viewDidAppear: must only be used on classes extending UIViewController. ");
#else
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"You must specify a selector name for page views on OS X."
                                         userInfo:nil];
#endif
        }
        
        // Try to grab the page name from the dictionary.
        NSString *dictionaryPageName = configurationDictionary[ARAnalyticsPageName];
        
        // If there wasn't one, then try to invoke keypath.
        NSString *pageNameKeypath = configurationDictionary[ARAnalyticsPageNameKeyPath];
        
        RSSwizzleClassMethod(klass, @selector(alloc), RSSWReturnType(id), void, RSSWReplacement({
            id instance = RSSWCallOriginal();
            __weak __typeof(instance) weakInstance = instance;
            [[instance rac_signalForSelector:selector] subscribeNext:^(RACTuple *parameters) {
                id instance = weakInstance;
                
                BOOL shouldFire = shouldFireForInstance(configurationDictionary, instance, parameters);
                
                if (shouldFire) {
                    NSString *pageName;
                    if (dictionaryPageName) {
                        pageName = dictionaryPageName;
                    } else {
                        pageName = [instance valueForKeyPath:pageNameKeypath];
                        NSAssert(pageName, @"Value for Key on `%@` returned nil.", pageNameKeypath);
                    }
                    
                    [ARAnalytics pageView:pageName];
                }
            }];
            return instance;
        }));
    }];
    
    NSArray *trackedEvents = configurationDictionary[ARAnalyticsTrackedEvents];
    [trackedEvents enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        Class klass = extractClassFromDictionary(object);
        
        NSString *selectorName = object[ARAnalyticsSelectorName];
        SEL selector = NSSelectorFromString(selectorName);
        NSAssert(selector != NULL, @"Event selector lookup failed. ");
        
        NSString *event = configurationDictionary[ARAnalyticsEventName];
        
        RSSwizzleClassMethod(klass, @selector(alloc), RSSWReturnType(id), void, RSSWReplacement({
            id instance = RSSWCallOriginal();
            __weak __typeof(instance) weakInstance = instance;
            [[instance rac_signalForSelector:selector] subscribeNext:^(RACTuple *parameters) {
                id instance = weakInstance;
                
                BOOL shouldFire = shouldFireForInstance(configurationDictionary, instance, parameters);
                
                if (shouldFire) {
                    NSDictionary *properties;
                    ARAnalyticsEventPropertiesBlock propertiesBlock = configurationDictionary[ARAnalyticsEventProperties];
                    if (propertiesBlock) {
                        properties = propertiesBlock(instance, parameters);
                    }
                    
                    [ARAnalytics event:event withProperties:properties];
                }
            }];
            return instance;
        }));
    }];
}

@end
