#import "ARAnalyticalProvider.h"

// Whilst we cannot include the Crashlytics library
// we can stub out the implementation with methods we want
// so that it will link with the real framework later on ./
#ifdef AR_FABRIC_EXISTS

@interface Fabric : NSObject
+ (instancetype)with:(NSArray *)kits;
+ (instancetype)sharedSDK;
@end

OBJC_EXTERN void CLSLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

#endif


@interface FabricProvider : ARAnalyticalProvider
- (instancetype)initWithKits:(NSArray *)kits;
@end
