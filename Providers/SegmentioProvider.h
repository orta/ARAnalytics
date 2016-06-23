//
//  SegmentioProvider.h
//
//

#import "ARAnalyticalProvider.h"

@interface SegmentioProvider : ARAnalyticalProvider
- (instancetype)initWithIdentifier:(NSString *)identifier integrations:(NSArray *)integrations;
@end
