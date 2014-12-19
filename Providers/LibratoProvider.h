#import "ARAnalyticalProvider.h"

// Whilst we do not include the Librato library
// as it is not an official one
// we can stub out the implementation with methods we want
// so that it will link with the real framework later on ./

#ifdef AR_LIBRATO_EXISTS

@interface Librato : NSObject
- (instancetype)initWithEmail:(NSString *)email token:(NSString *)apiKey prefix:(NSString *)prefix;
- (void)add:(id)metrics;
@end

@interface LibratoMetric : NSObject
+ (instancetype)metricNamed:(NSString *)name valued:(NSNumber *)value;
@end

#endif

@interface LibratoProvider : ARAnalyticalProvider

- (instancetype)initWithEmail:(NSString *)email token:(NSString *)token prefix:(NSString *)prefix;

@end
