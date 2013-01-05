//
//  ARAnalyticalProvider.h
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//

#import <Foundation/Foundation.h>
                
@implementation ARAnalyticalProvider

/// Set a per user property
- (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {}
- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {}

/// Submit user events
- (void)event:(NSString *)event {}
- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {}
- (void)incrementUserProperty:(NSString*)counterName byInt:(int)amount {}

/// Monitor Navigation changes as page view
- (void)monitorNavigationViewController:(UINavigationController *)controller {}

/// Let ARAnalytics deal with the timing of an event
- (void)startTimingEvent:(NSString *)event {}
- (void)finishTimingEvent:(NSString *)event {}

@end
