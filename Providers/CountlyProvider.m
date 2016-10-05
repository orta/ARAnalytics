#import "CountlyProvider.h"
#import "Countly.h"

@implementation CountlyProvider

- (instancetype)initWithAppKey:(NSString *)appKey andHost:(NSString *)host {
#ifdef AR_COUNTLY_EXISTS
    NSAssert([Countly class], @"Countly is not included");

    // since v16.0
    if ([[Countly sharedInstance] respondsToSelector:@selector(startWithConfig:)]) {
        CountlyConfig *config = [CountlyConfig new];
        config.appKey = appKey;
        if (host) {
            config.host = host;
        }
        [[Countly sharedInstance] performSelector:@selector(startWithConfig:) withObject:config];
    }
    // before v16.0
    else if ([[Countly sharedInstance] respondsToSelector:@selector(start:withHost:)]) {
        if (host) {
            [[Countly sharedInstance] performSelector:@selector(start:withHost:) withObject:appKey withObject:host];
        } else {
            [[Countly sharedInstance] performSelector:@selector(startOnCloudWithAppKey:) withObject:appKey];
        }
    }
#endif

    return [super init];
}

#ifdef AR_COUNTLY_EXISTS

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [[Countly sharedInstance] recordEvent:event segmentation:properties count:1];
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {
    [self event:pageTitle withProperties:properties];
}

#endif
@end
