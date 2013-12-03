//
//  NSDictionary+GoogleAnalytics.m
//  Pods
//
//  Created by Ian Grossberg on 12/3/13.
//
//

#import "NSDictionary+GoogleAnalytics.h"

#import "NSMutableDictionary+GoogleAnalytics.h"

@implementation NSDictionary (GoogleAnalytics)

+ (NSDictionary *)dictionaryWithCategory:(NSString *)category {
    return [self dictionaryWithCategory:category withLabel:nil];
}

+ (NSDictionary *)dictionaryWithCategory:(NSString *)category withLabel:(NSString *)label {
    return [self dictionaryWithCategory:category withLabel:label withValue:nil];
}

+ (NSDictionary *)dictionaryWithCategory:(NSString *)category withLabel:(NSString *)label withValue:(NSNumber *)value {
//  We could do this but we wouldn't be taking advantage of our nil safe setters
//    return @{
//             [NSDictionary googleAnalyticsCategoryKey] : category,
//             [NSDictionary googleAnalyticsLabelKey] : label,
//             [NSDictionary googleAnalyticsValueKey] : value
//             };
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary.category = category;
    dictionary.label = label;
    dictionary.value = value;
    return dictionary;
}

#pragma mark category property
+ (NSString *)googleAnalyticsCategoryKey {
    return @"category";
}

- (NSString *)category {
    return [self valueForKey:[NSDictionary googleAnalyticsCategoryKey] ];
}

#pragma mark label property
+ (NSString *)googleAnalyticsLabelKey {
    return @"label";
}

- (NSString *)label {
    return [self valueForKey:[NSDictionary googleAnalyticsLabelKey] ];
}

#pragma mark value property
+ (NSString *)googleAnalyticsValueKey {
    return @"value";
}

- (NSNumber *)value
{
    return [self valueForKey:[NSDictionary googleAnalyticsValueKey] ];
}

@end
