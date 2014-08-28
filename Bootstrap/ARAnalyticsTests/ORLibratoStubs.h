//
//  ORLibratoStubs.h
//  ARAnalyticsTests
//
//  Created by Orta on 8/27/14.
//  Copyright (c) 2014 Orta Therox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Librato : NSObject
- (instancetype)initWithEmail:(NSString *)email token:(NSString *)apiKey prefix:(NSString *)prefix;
- (void)add:(id)metrics;
@end

@interface LibratoMetric : NSObject
+ (instancetype)metricNamed:(NSString *)name valued:(NSNumber *)value;
@end
