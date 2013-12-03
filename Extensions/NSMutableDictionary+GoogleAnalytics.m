//
//  NSMutableDictionary+GoogleAnalytics.m
//  Pods
//
//  Created by Ian Grossberg on 12/3/13.
//
//

#import "NSMutableDictionary+GoogleAnalytics.h"

#import "NSDictionary+GoogleAnalytics.h"

@implementation NSMutableDictionary (GoogleAnalytics)

#pragma mark category property
- (void)setCategory:(NSString *)category {
    
    if (category) {
        [self setValue:category forKey:[NSDictionary googleAnalyticsCategoryKey] ];
    } else {
        [self removeObjectForKey:[NSDictionary googleAnalyticsCategoryKey] ];
    }
}

#pragma mark label property
- (void)setLabel:(NSString *)label {
    
    if (label) {
        [self setValue:label forKey:[NSDictionary googleAnalyticsLabelKey] ];
    } else {
        [self removeObjectForKey:[NSDictionary googleAnalyticsLabelKey] ];
    }
}

#pragma mark value property
- (void)setValue:(NSNumber *)value {
    
    if (value) {
        [self setValue:value forKey:[NSDictionary googleAnalyticsValueKey] ];
    } else {
        [self removeObjectForKey:[NSDictionary googleAnalyticsValueKey] ];
    }
}

@end
