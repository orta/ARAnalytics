//
//  ARAnalyticalProvider.h
//  Art.sy
//
//  Created by orta therox on 18/12/2012.
//  Copyright (c) 2012 Art.sy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARAnalyticalProvider.h"
                
@implementation ARAnalyticalProvider

- (id)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    return self;
}

/// Set a per user property
- (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email {}
- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {}

/// Submit user events
- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {}
- (void)incrementUserProperty:(NSString *)counterName byInt:(NSNumber *)amount {}

/// Monitor Navigation changes as page view
- (void)monitorNavigationViewController:(UINavigationController *)controller {}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval {
    [self event:event withProperties:@{ @"length": interval }];
}

- (void)didShowNewViewController:(UIViewController *)controller {
    [self event:@"Screen view" withProperties:@{ @"screen": controller.title }];
}

- (void)remoteLog:(NSString *)parsedString {}

@end
