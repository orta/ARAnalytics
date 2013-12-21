//
//  ChartbeatProvider.m
//  ARAnalytics
//
//  Created by Samuel E. Giddins on 12/19/2013.
//

#import "ARAnalytics+Chartbeat.h"
#import "ChartbeatProvider.h"
#import "CBTracker.h"

@implementation ARAnalytics (Chartbeat)

+ (void)trackView:(UIScrollView *)view ID:(NSString *)ID title:(NSString *)title
{
    [[CBTracker sharedTracker] trackView:view viewId:ID title:title];
    [self pageView:title];
}

@end
