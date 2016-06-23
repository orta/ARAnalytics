//
//  SnowPlowProvider.m
//
//  Created by Orta Therox

#import "ARAnalyticsProviders.h"
#import "SnowPlowProvider.h"
#import "SnowplowTracker.h"
#import "SnowplowEmitter.h"

@interface SnowplowProvider ()
@property (nonatomic, strong, readonly) SnowplowEmitter *defaultEmitter;
@property (nonatomic, strong, readonly) SnowplowTracker *tracker;
@end

@implementation SnowplowProvider

- (instancetype)initWithAddress:(NSString *)address
{
    NSString *bundleID  = [[NSBundle mainBundle] bundleIdentifier];
    return [self initWithAddress:address appID:bundleID namespace:nil];
}

- (instancetype)initWithAddress:(NSString *)address appID:(NSString *)appID namespace:(NSString *)namespace
{
    SnowplowEmitter *emitter = [[SnowplowEmitter alloc] initWithURLRequest:[NSURL URLWithString:address]];
    return [self initWithEmitter:emitter appID:appID namespace:namespace];
}

- (instancetype)initWithEmitter:(SnowplowEmitter *)emitter appID:(NSString *)appID namespace:(NSString *)namespace
{
    self = [super initWithIdentifier:appID];
    if (!self) return nil;

    _defaultEmitter = emitter;
    _tracker = [[SnowplowTracker alloc] initWithCollector:_defaultEmitter appId:appID base64Encoded:YES namespace:namespace];

    return self;
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties
{
    [self.tracker trackUnstructuredEvent:properties];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email
{
    [self.tracker setUserId:userID];
}

- (void)didShowNewPageView:(NSString *)pageTitle
{
    [self.tracker trackPageView:nil title:pageTitle referrer:nil];
}
@end
