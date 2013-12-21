//
//  ARAnalytics+Chartbeat.h
//  ARAnalytics
//
//  Created by Samuel E. Giddins on 12/19/2013.
//

#import "ARAnalytics.h"

@interface ARAnalytics (Chartbeat)

+ (void)trackView:(UIView *)view ID:(NSString *)ID title:(NSString *)title;

@end
