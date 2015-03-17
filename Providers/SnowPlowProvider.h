//
//  SnowPlowProvider.h
//
//  Created by Orta Therox

#import "ARAnalyticalProvider.h"

@class SnowplowEmitter;
@interface SnowplowProvider : ARAnalyticalProvider

- (id)initWithAddress:(NSString *)address;
- (id)initWithAddress:(NSString *)address appID:(NSString *)appID namespace:(NSString *)namespace;
- (id)initWithEmitter:(SnowplowEmitter *)emitter appID:(NSString *)appID namespace:(NSString *)namespace;

@end
