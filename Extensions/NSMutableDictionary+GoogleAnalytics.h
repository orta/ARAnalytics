//
//  NSMutableDictionary+GoogleAnalytics.h
//  Pods
//
//  Created by Ian Grossberg on 12/3/13.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (GoogleAnalytics)

// Google Analytics' event properties
@property (readwrite) NSString *category;
@property (readwrite) NSString *label;
@property (readwrite) NSNumber *value;

@end
