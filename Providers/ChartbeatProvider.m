//
//  ChartbeatProvider.m
//  ARAnalytics
//
//  Created by Samuel E. Giddins on 12/19/2013.
//

#import "ChartbeatProvider.h"
#import "CBTracker.h"

@interface ChartbeatProvider ()

@end

@implementation ChartbeatProvider
#ifdef AR_CHARTBEAT_EXISTS

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    [[CBTracker sharedTracker] startTrackerWithAccountID:identifier.intValue];
    return self;
}

#endif
@end
