#import "ARDSL.h"
#import <RSSwizzle/RSSwizzle.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString * const ARAnalyticsTrackedEvents = @"trackedEvents";
NSString * const ARAnalyticsTrackedScreens = @"trackedScreens";

NSString * const ARAnalyticsClass = @"class";
NSString * const ARAnalyticsDetails = @"details";
NSString * const ARAnalyticsPageName = @"pageName";
NSString * const ARAnalyticsPageNameKeyPath = @"keypath";
NSString * const ARAnalyticsEventName = @"event";
NSString * const ARAnalyticsSelectorName = @"selector";
NSString * const ARAnalyticsEventProperties = @"properties";
NSString * const ARAnalyticsShouldFire = @"shouldFire";;

static BOOL ar_shouldFireForInstance (NSDictionary *dictionary, id instance, NSArray *arguments) {
    ARAnalyticsEventShouldFireBlock shouldFireBlock = dictionary[ARAnalyticsShouldFire];

    BOOL shouldFire;
    if (shouldFireBlock) {
        shouldFire = shouldFireBlock(instance, arguments);
    } else {
        shouldFire = YES;
    }

    return shouldFire;
}

@implementation ARAnalytics (DSL)

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary {
    [self setupWithAnalytics:analyticsDictionary];

    NSArray *trackedScreenClasses = configurationDictionary[ARAnalyticsTrackedScreens];
    [trackedScreenClasses enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        Class klass = object[ARAnalyticsClass];

        NSArray *analyticsDetails = object[ARAnalyticsDetails];

        RSSwizzleClassMethod(klass, @selector(alloc), RSSWReturnType(id), void, RSSWReplacement({
            id instance = RSSWCallOriginal();
            __weak __typeof(instance) weakInstance = instance;

            [analyticsDetails enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
                SEL selector;
                NSString *selectorName = object[ARAnalyticsSelectorName];
                if (selectorName) {
                    selector = NSSelectorFromString(selectorName);
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
                NSString *dictionaryPageName = object[ARAnalyticsPageName];

                // If there wasn't one, then try to invoke keypath.
                NSString *pageNameKeypath = object[ARAnalyticsPageNameKeyPath];

                [[instance rac_signalForSelector:selector] subscribeNext:^(RACTuple *parameters) {
                    id instance = weakInstance;

                    BOOL shouldFire = ar_shouldFireForInstance(object, instance, parameters);

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
            }];

            return instance;
        }));
    }];

    NSArray *trackedEventClasses = configurationDictionary[ARAnalyticsTrackedEvents];
    [trackedEventClasses enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        Class klass = object[ARAnalyticsClass];

        NSArray *analyticsDetails = object[ARAnalyticsDetails];

        RSSwizzleClassMethod(klass, @selector(alloc), RSSWReturnType(id), void, RSSWReplacement({
            id instance = RSSWCallOriginal();
            __weak __typeof(instance) weakInstance = instance;


            [analyticsDetails enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
                NSString *selectorName = object[ARAnalyticsSelectorName];
                SEL selector = NSSelectorFromString(selectorName);
                NSAssert(selector != NULL, @"Event selector lookup failed. ");

                NSString *event = object[ARAnalyticsEventName];

                [[instance rac_signalForSelector:selector] subscribeNext:^(RACTuple *parameters) {
                    id instance = weakInstance;

                    BOOL shouldFire = ar_shouldFireForInstance(object, instance, parameters);

                    if (shouldFire) {
                        NSDictionary *properties;
                        ARAnalyticsEventPropertiesBlock propertiesBlock = object[ARAnalyticsEventProperties];
                        if (propertiesBlock) {
                            properties = propertiesBlock(instance, parameters);
                        }

                        [ARAnalytics event:event withProperties:properties];
                    }
                }];
            }];

            return instance;
        }));
    }];
}

//+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary {
//    [self setupWithAnalytics:analyticsDictionary];
//    
//    void (^assertionBlock)(void (^)(void)) = ^(void (^block)(void)){
//        NSParameterAssert(block);
//        BOOL failed = NO;
//        
//        @try {
//            block();
//        }
//        @catch (NSException *exception) {
//            failed = YES;
//        }
//        @finally {
//            NSAssert(failed == NO, @"There was an error setting up ARAnalytics' using the DSL. Likely, something went wrong with a selector lookup. Double check your configurationDictionary.");
//        }
//    };
//
//    NSArray *trackedScreenClasses = configurationDictionary[ARAnalyticsTrackedScreens];
//    [trackedScreenClasses enumerateObjectsUsingBlock:^(NSDictionary *screenDictionary, NSUInteger idx, BOOL *stop) {
//        assertionBlock(^{
//            [self addScreenMonitoringAnalyticsHook:screenDictionary];
//        });
//    }];
//
//    NSArray *trackedEventClasses = configurationDictionary[ARAnalyticsTrackedEvents];
//    [trackedEventClasses enumerateObjectsUsingBlock:^(NSDictionary *eventDictionary, NSUInteger idx, BOOL *stop) {
//        assertionBlock(^{
//            [self addEventAnalyticsHooks:eventDictionary];
//        });
//    }];
//}
//
//+ (void)addEventAnalyticsHooks:(NSDictionary *)eventDictionary {
//    Class klass = eventDictionary[ARAnalyticsClass];
//
//    NSArray *analyticsDetails = eventDictionary[ARAnalyticsDetails];
//
//    [analyticsDetails enumerateObjectsUsingBlock:^(NSDictionary *detailsDictionary, NSUInteger idx, BOOL *stop) {
//        NSError *error = nil;
//        SEL selector = [self selectorForEventAnalyticsDetails:detailsDictionary];
//        NSString *event = detailsDictionary[ARAnalyticsEventName];
//
//        id aspectRef = [klass aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(__unsafe_unretained id instance, NSArray *arguments) {
//
//            BOOL shouldFire = ar_shouldFireForInstance(detailsDictionary, instance, arguments);
//
//            if (shouldFire) {
//                NSDictionary *properties = nil;
//                ARAnalyticsEventPropertiesBlock propertiesBlock = detailsDictionary[ARAnalyticsEventProperties];
//                if (propertiesBlock) {
//                    properties = propertiesBlock(instance, arguments);
//                }
//
//                [ARAnalytics event:event withProperties:properties];
//            }
//        } error:&error];
//
//        if (error) {
//            NSLog(@"ARAnalytics DSL: Error setting up hook for %@ on %@ -  %@", klass, NSStringFromSelector(selector), error.localizedDescription);
//
//        } else {
//            [self storeAspectRef:aspectRef forClass:klass andSelector:selector];
//        }
//    }];
//}
//
//
//+ (void)addScreenMonitoringAnalyticsHook:(NSDictionary *)screenDictionary {
//
//    Class klass = screenDictionary[ARAnalyticsClass];
//    NSArray *analyticsDetails = screenDictionary[ARAnalyticsDetails];
//
//    [analyticsDetails enumerateObjectsUsingBlock:^(id analyticsDictionary, NSUInteger idx, BOOL *stop) {
//        NSError *error = nil;
//        SEL selector = [self selectorForScreenAnalyticsDetails:analyticsDictionary class:klass];
//
//        // Try to grab the page name from the dictionary.
//        NSString *dictionaryPageName = analyticsDictionary[ARAnalyticsPageName];
//
//        // If there wasn't one, then try to invoke keypath.
//        NSString *pageNameKeypath = analyticsDictionary[ARAnalyticsPageNameKeyPath];
//
//       id aspectRef = [klass aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(__unsafe_unretained id instance, NSArray *arguments) {
//
//            BOOL shouldFire = ar_shouldFireForInstance(analyticsDictionary, instance, arguments);
//
//            if (shouldFire) {
//                NSString *pageName;
//                if (dictionaryPageName) {
//                    pageName = dictionaryPageName;
//                } else {
//                    pageName = [instance valueForKeyPath:pageNameKeypath];
//                    NSAssert(pageName, @"Value for Key on `%@` returned nil from instance of class: `%@`", pageNameKeypath, NSStringFromClass([instance class]));
//                }
//
//                [ARAnalytics pageView:pageName];
//            }
//        } error:&error];
//
//        if (error) {
//            NSLog(@"ARAnalytics DSL: Error setting up hook for %@ on %@ -  %@", klass, NSStringFromSelector(selector), error.localizedDescription);
//
//        } else {
//            [self storeAspectRef:aspectRef forClass:klass andSelector:selector];
//        }
//    }];
//}
//
//+ (SEL)selectorForEventAnalyticsDetails:(NSDictionary *)detailsDictionary
//{
//    NSString *selectorName = detailsDictionary[ARAnalyticsSelectorName];
//    SEL selector = NSSelectorFromString(selectorName);
//    NSAssert(selector != NULL, @"Event selector lookup failed.");
//    return selector;
//}
//
//
//+ (SEL)selectorForScreenAnalyticsDetails:(NSDictionary *)dictionary class:(Class)klass
//{
//    SEL selector;
//    NSString *selectorName = dictionary[ARAnalyticsSelectorName];
//    if (selectorName) {
//        selector = NSSelectorFromString(selectorName);
//
//    } else {
//
//#if TARGET_OS_IPHONE
//        selector = @selector(viewDidAppear:);
//        NSAssert([[klass new] isKindOfClass:[UIViewController class]], @"Default selector of viewDidAppear: must only be used on classes extending UIViewController. ");
//#else
//            @throw [NSException exceptionWithName:NSInternalInconsistencyException
//                                           reason:@"You must specify a selector name for page views on OS X."
//                                         userInfo:nil];
//#endif
//    }
//    return selector;
//}
//
//
//NSString *ARKeyForClassAndSelector(Class klass, SEL selector) {
//    return [NSStringFromClass(klass) stringByAppendingFormat:@"-%@", NSStringFromSelector(selector)];
//}
//
//+ (void)storeAspectRef:(id)ref forClass:(Class)klass andSelector:(SEL)selector {
//    if(!ARAnalyticsHooksStore){
//        ARAnalyticsHooksStore = [NSMutableDictionary dictionary];
//    }
//
//    NSString *key = ARKeyForClassAndSelector(klass, selector);
//    ARAnalyticsHooksStore[key] = ref;
//}
//
//+ (BOOL)removeEventsAnalyticsHooks:(NSDictionary *)analyticsDictionary
//{
//    SEL selector = [self selectorForEventAnalyticsDetails:analyticsDictionary];
//    Class klass = analyticsDictionary[ARAnalyticsClass];
//
//    NSString *key = ARKeyForClassAndSelector(klass, selector);
//    id <Aspect> aspectRef = ARAnalyticsHooksStore[key];
//
//    return [aspectRef remove];
//}
//
//+ (BOOL)removeScreenMonitoringAnalyticsHooks:(NSDictionary *)screenDictionary
//{
//    Class klass = screenDictionary[ARAnalyticsClass];
//    SEL selector = [self selectorForScreenAnalyticsDetails:screenDictionary[ARAnalyticsDetails] class:klass];
//
//    NSString *key = ARKeyForClassAndSelector(klass, selector);
//    id <Aspect> aspectRef = ARAnalyticsHooksStore[key];
//
//    return [aspectRef remove];
//}
//
//+ (BOOL)removeAllAnalyticsHooks
//{
//    __block BOOL success = YES;
//    [ARAnalyticsHooksStore enumerateKeysAndObjectsUsingBlock:^(NSString *key, id <Aspect> aspectRef, BOOL *stop) {
//
//        if ([aspectRef remove] == NO){
//            success = NO;
//        }
//    }];
//    [ARAnalyticsHooksStore removeAllObjects];
//    return success;
//}

@end
