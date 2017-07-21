#import "ARDSL.h"
#import <RSSwizzle/RSSwizzle.h>
#import <ReactiveObjC/ReactiveObjC.h>

NSString * const ARAnalyticsTrackedEvents = @"trackedEvents";
NSString * const ARAnalyticsTrackedScreens = @"trackedScreens";

NSString * const ARAnalyticsClass = @"class";
NSString * const ARAnalyticsDetails = @"details";
NSString * const ARAnalyticsProperties = @"properties";
NSString * const ARAnalyticsPageName = @"pageName";
NSString * const ARAnalyticsPageNameKeyPath = @"keypath";
NSString * const ARAnalyticsPageNameBlock = @"pageNameBlock";
NSString * const ARAnalyticsEventName = @"event";
NSString * const ARAnalyticsEventNameBlock = @"eventBlock";
NSString * const ARAnalyticsSelectorName = @"selector";
NSString * const ARAnalyticsEventProperties = @"properties";
NSString * const ARAnalyticsShouldFire = @"shouldFire";

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

static NSDictionary *
ARExtractProperties(id object, NSDictionary *analyticsEntry, RACTuple *parameters)
{
    ARAnalyticsPropertiesBlock propertiesBlock = analyticsEntry[ARAnalyticsProperties];
    if (propertiesBlock) {
        return propertiesBlock(object, parameters.allObjects);
    }
    return nil;
}

static NSString *
ARExtractPageName(id object, NSDictionary *analyticsEntry, RACTuple *parameters, NSDictionary *extractedProperties)
{
    ARAnalyticsNameBlock pageNameBlock = analyticsEntry[ARAnalyticsPageNameBlock];
    if (pageNameBlock) {
        return pageNameBlock(object, parameters.allObjects, extractedProperties);
    }
    return nil;
}

static NSString *
ARExtractEventName(id object, NSDictionary *analyticsEntry, RACTuple *parameters, NSDictionary *extractedProperties)
{
    ARAnalyticsNameBlock eventNameBlock = analyticsEntry[ARAnalyticsEventNameBlock];
    if (eventNameBlock) {
        return eventNameBlock(object, parameters.allObjects, extractedProperties);
    }
    return nil;
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
                    NSString *eventName = event;
                    NSDictionary *properties = ARExtractProperties(instance, object, parameters);

                    if (!eventName) {
                        // if the event name was not set statically, see if it's available via the block parameter
                        eventName = ARExtractEventName(instance, object, parameters, properties);
                    }
                    [ARAnalytics event:eventName withProperties:properties];
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
                if (instance == nil) {
                    return;
                }

                BOOL shouldFire = ar_shouldFireForInstance(object, instance, parameters);

                if (shouldFire) {
                    NSString *pageName;
                    NSDictionary *properties = ARExtractProperties(instance, object, parameters);

                    if (dictionaryPageName) {
                        pageName = dictionaryPageName;
                    } else if (pageNameKeypath) {
                        pageName = [instance valueForKeyPath:pageNameKeypath];
                        NSAssert(pageName, @"Value for Key on `%@` returned nil.", pageNameKeypath);
                    } else {
                        // if we still don't have a page name, check to see if it is supplied dynamically
                        pageName = ARExtractPageName(instance, object, parameters, properties);
                    }

                    // Because of backwards compatibility we can't currently expect
                    // `-[ARAnalyticsProvider pageView:withProperties:]` to call existing
                    // `-[ARAnalyticsProvider pageView:]` implementations, so call the right one.
                    if (properties) {
                        [ARAnalytics pageView:pageName withProperties:properties];
                    } else {
                        [ARAnalytics pageView:pageName];
                    }
                }
            }];
        }];

        return instance;
    }));
}

@end
