#import "ARAnalyticalProvider.h"

@interface MobileAppTrackerProvider : ARAnalyticalProvider

/** Each event has associated billing charges, so we don't necessarely want every event to be sent.
 *  @link http://help.tune.com/marketing-console/in-app-events-which-ones-you-should-be-measuring-and-why/
 */
@property (nonatomic, strong) NSArray *allowedEvents;

- (instancetype)initWithAdvertiserId:(NSString *)advertiserId
                       conversionKey:(NSString *)conversionKey
                       allowedEvents:(NSArray *)allowedEvents;

@end
