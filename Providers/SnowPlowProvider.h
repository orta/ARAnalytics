//
//  SnowPlowProvider.h
//
//  Created by Orta Therox

#import "ARAnalyticalProvider.h"

@class SnowplowEmitter;
@interface SnowplowProvider : ARAnalyticalProvider

- (instancetype)initWithAddress:(NSString *)address;
- (instancetype)initWithAddress:(NSString *)address appID:(NSString *)appID namespace:(NSString *)namespace;
- (instancetype)initWithEmitter:(SnowplowEmitter *)emitter appID:(NSString *)appID namespace:(NSString *)namespace;

@end
