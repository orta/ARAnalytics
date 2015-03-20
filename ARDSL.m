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

static BOOL ar_shouldFireForInstance (NSDictionary *dictionary, id instance, RACTuple *context) {
    ARAnalyticsEventShouldFireBlock shouldFireBlock = dictionary[ARAnalyticsShouldFire];

    BOOL shouldFire;
    if (shouldFireBlock) {
        shouldFire = shouldFireBlock(instance, context.allObjects);
    } else {
        shouldFire = YES;
    }

    return shouldFire;
}

static SEL ar_selectorForEventAnalyticsDetails (NSDictionary *detailsDictionary) {
    NSString *selectorName = detailsDictionary[ARAnalyticsSelectorName];
    SEL selector = NSSelectorFromString(selectorName);
    return selector;
}

static SEL ar_selectorForScreenAnalyticsDetails (NSDictionary *dictionary, Class klass) {
    SEL selector;
    NSString *selectorName = dictionary[ARAnalyticsSelectorName];
    if (selectorName) {
        selector = NSSelectorFromString(selectorName);
    } else {
#if TARGET_OS_IPHONE
        selector = @selector(viewDidAppear:);
        NSCAssert([klass isSubclassOfClass:UIViewController.class] || klass == UIViewController.class, @"Default selector of viewDidAppear: must only be used on classes extending UIViewController or UIViewController itself.");
#else
        NSCAssert(NO, @"You must specify a selector name for page views on OS X.");
#endif
    }
    return selector;
}

@implementation ARAnalytics (DSL)

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary configuration:(NSDictionary *)configurationDictionary {
    [self setupWithAnalytics:analyticsDictionary];

    NSArray *trackedScreenClasses = configurationDictionary[ARAnalyticsTrackedScreens];
    [trackedScreenClasses enumerateObjectsUsingBlock:^(NSDictionary *screenDictionary, NSUInteger idx, BOOL *stop) {
        [self addScreenMonitoringAnalyticsHook:screenDictionary];
    }];

    NSArray *trackedEventClasses = configurationDictionary[ARAnalyticsTrackedEvents];
    [trackedEventClasses enumerateObjectsUsingBlock:^(NSDictionary *eventDictionary, NSUInteger idx, BOOL *stop) {
        [self addEventAnalyticsHook:eventDictionary];
    }];
}

+ (void)addEventAnalyticsHook:(NSDictionary *)eventDictionary {
    Class klass = eventDictionary[ARAnalyticsClass];

    RSSwizzleClassMethod(klass, @selector(alloc), RSSWReturnType(id), void, RSSWReplacement({
        id instance = RSSWCallOriginal();

        [eventDictionary[ARAnalyticsDetails] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            SEL selector = ar_selectorForEventAnalyticsDetails(object);

            NSString *event = object[ARAnalyticsEventName];

            __weak __typeof(instance) weakInstance = instance;
            [[instance rac_signalForSelector:selector] subscribeNext:^(RACTuple *parameters) {
                id instance = weakInstance;

                BOOL shouldFire = ar_shouldFireForInstance(object, instance, parameters);

                if (shouldFire) {
                    NSDictionary *properties;
                    ARAnalyticsEventPropertiesBlock propertiesBlock = object[ARAnalyticsEventProperties];
                    if (propertiesBlock) {
                        properties = propertiesBlock(instance, parameters.allObjects);
                    }

                    [ARAnalytics event:event withProperties:properties];
                }
            }];
        }];

        return instance;
    }));
}

+ (void)addScreenMonitoringAnalyticsHook:(NSDictionary *)screenDictionary {
    Class klass = screenDictionary[ARAnalyticsClass];

    RSSwizzleClassMethod(klass, @selector(alloc), RSSWReturnType(id), void, RSSWReplacement({
        id instance = RSSWCallOriginal();

        [screenDictionary[ARAnalyticsDetails] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            SEL selector = ar_selectorForScreenAnalyticsDetails(object, klass);

            // Try to grab the page name from the dictionary.
            NSString *dictionaryPageName = object[ARAnalyticsPageName];

            // If there wasn't one, then try to invoke keypath.
            NSString *pageNameKeypath = object[ARAnalyticsPageNameKeyPath];

            __weak __typeof(instance) weakInstance = instance;
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
}

@end
