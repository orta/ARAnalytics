//
//  NSDictionary+GoogleAnalytics.h
//  Pods
//
//  Created by Ian Grossberg on 12/3/13.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GoogleAnalytics)

+ (NSDictionary *)dictionaryWithCategory:(NSString *)category;
+ (NSDictionary *)dictionaryWithCategory:(NSString *)category withLabel:(NSString *)label;
+ (NSDictionary *)dictionaryWithCategory:(NSString *)category withLabel:(NSString *)label withValue:(NSNumber *)value;

// Google Analytics' event properties
@property (readonly) NSString *category;
@property (readonly) NSString *label;
@property (readonly) NSNumber *value;

+ (NSString *)googleAnalyticsCategoryKey;
+ (NSString *)googleAnalyticsLabelKey;
+ (NSString *)googleAnalyticsValueKey;

@end
