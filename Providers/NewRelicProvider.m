#import "NewRelicProvider.h"
#import <NewRelicAgent/NewRelic.h>

@implementation NewRelicProvider

- (instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([NewRelic class], @"NewRelic is not included");
    [NewRelic startWithApplicationToken:identifier];
    
    return [super init];
}

@end
