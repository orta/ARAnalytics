#import "LibratoProvider.h"

@interface LibratoProvider ()

@property Librato *client;

@end

@implementation LibratoProvider
#ifdef AR_LIBRATO_EXISTS

- (instancetype)initWithEmail:(NSString *)email token:(NSString *)token prefix:(NSString *)prefix {
    NSAssert([Librato class], @"Librato is not included");
    
    self.client = [[Librato alloc] initWithEmail:email token:token prefix:prefix];
    
    return [super init];
}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval properties:(NSDictionary *)properties {
    
    // convert metric to milliseconds
    NSNumber *metricValue = [NSNumber numberWithInteger:roundf(interval.floatValue*1000)];
    
    LibratoMetric *metric = [LibratoMetric metricNamed:event valued:metricValue];
    [self.client add:metric];
}

#endif
@end
