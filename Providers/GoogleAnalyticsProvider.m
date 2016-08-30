#import "GoogleAnalyticsProvider.h"
#import "ARAnalyticsProviders.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "NSDictionary+GoogleAnalytics.h"

@interface GoogleAnalyticsProvider ()

@property (nonatomic, strong) id <GAITracker> tracker;

- (void) dispatchGA;

@end

@implementation GoogleAnalyticsProvider
#ifdef AR_GOOGLEANALYTICS_EXISTS

- (instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([GAI class], @"Google Analytics SDK is not included");

    if ((self = [super init])) {
        self.tracker = [[GAI sharedInstance] trackerWithTrackingId:identifier];

        for( NSString *inactiveEvent in @[ UIApplicationWillResignActiveNotification,
                                           UIApplicationWillTerminateNotification,
                                           UIApplicationDidEnterBackgroundNotification ]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(dispatchGA)
                                                         name:inactiveEvent
                                                       object:nil];
        }
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    // The Google Analytics Terms of Service prohibit sending of any personally identifiable information (PII) to Google Analytics servers. For more information, please consult the Terms of Service.
    // https://developers.google.com/analytics/devguides/collection/ios/v3/customdimsmets#pii

    // Ideally we would put an assert here but if you have multiple providers that wouldn't make sense.

    // However setting of a User ID is allowed as per https://developers.google.com/analytics/devguides/collection/ios/v3/user-id .
    [self setUserProperty:@"&uid" toValue:userID];
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
    [self.tracker set:property value:value];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSString *category = properties.category;
    if (!category) {
        category = @"default"; // category is a required value
    }

    [self send:[self finalizedPropertyDictionaryFromBuilder:[GAIDictionaryBuilder
                                                                     createEventWithCategory:category
                                                                     action:event
                                                                     label:properties.label
                                                                     value:properties.value]
                                                     withProperties:properties]];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [self didShowNewPageView:pageTitle withProperties:nil];
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {
    if (!properties) {
        properties = @{@"label": pageTitle};
    } else {
        NSMutableDictionary *newProperties = [properties mutableCopy];
        newProperties[@"label"] = pageTitle;
        properties = newProperties;
    }

    [self event:ARAnalyticalProviderNewPageViewEventName withProperties:properties];

    [self.tracker set:kGAIScreenName value:pageTitle];
    GAIDictionaryBuilder *builder = nil;
    if ([GAIDictionaryBuilder respondsToSelector:@selector(createScreenView)]) {
        builder = [GAIDictionaryBuilder createScreenView];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        builder = [GAIDictionaryBuilder createAppView];
#pragma clang diagnostic pop
    }
    [self send:[self finalizedPropertyDictionaryFromBuilder:builder withProperties:properties]];
}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval properties:(NSDictionary *)properties {
    // Prepare properties dictionary
    if (!properties) {
        properties = @{@"value": @([interval intValue])};
    } else {
        NSMutableDictionary *newProperties = [properties mutableCopy];
        newProperties[@"value"] = @([interval intValue]);
        properties = newProperties;
    }
    
    // Send event
    [self event:event withProperties:properties];
    
    // By Google's header, the interval should be seconds in milliseconds.
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createTimingWithCategory:properties.category ?: @"default"
                                                                          interval:@((int)([interval doubleValue]*1000))
                                                                              name:event
                                                                             label:nil];
    [self send:[self finalizedPropertyDictionaryFromBuilder:builder withProperties:properties]];
}

- (NSMutableDictionary *)finalizedPropertyDictionaryFromBuilder:(GAIDictionaryBuilder *)builder
                                                 withProperties:(NSDictionary *)properties {
    NSMutableDictionary *finalizedProperties = [builder build];

#ifdef DEBUG
    [self warnAboutIgnoredProperties:properties];
#endif

    // adding custom Dimension values if we can find a key in the mappings
    for (NSString *key in self.customDimensionMappings.allKeys) {
        NSString *potentialValue = properties[key];
        if (potentialValue) {
            [finalizedProperties setObject:potentialValue forKey:self.customDimensionMappings[key]];
        }
    }

    // adding custom Metric values if we can find a key in the mappings
    for (NSString *key in self.customMetricMappings.allKeys) {
        NSString *potentialValue = properties[key];
        if (potentialValue) {
            [finalizedProperties setObject:potentialValue forKey:self.customMetricMappings[key]];
        }
    }

    return finalizedProperties;
}

#pragma mark - Dispatch

- (void)dispatchGA {
    [[GAI sharedInstance] dispatch];
}

- (void)send:(NSDictionary *)parameters {
	[self.tracker send:parameters];
	//	send events immediately while debugging
#ifdef DEBUG
	[self dispatchGA];
#endif
}

#pragma mark - Warnings

- (void)warnAboutIgnoredProperties:(NSDictionary*)propertiesDictionary {
    for (NSString *key in propertiesDictionary) {
        if ([key isEqualToString:[NSDictionary googleAnalyticsLabelKey]] ||
            [key isEqualToString:[NSDictionary googleAnalyticsCategoryKey]] ||
            [key isEqualToString:[NSDictionary googleAnalyticsValueKey]] ||
            [self.customDimensionMappings.allKeys containsObject:key]) {
            continue;
        }
        NSLog(@"%@: property ignored %@:%@",self,key,propertiesDictionary[key]);
    }
}

#endif

@end