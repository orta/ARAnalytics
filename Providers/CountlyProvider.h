//
//  CountlyProvider.h
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "ARAnalyticalProvider.h"

@interface CountlyProvider : ARAnalyticalProvider
- (id)initWithAppKey:(NSString *)appKey andHost:(NSString *)host;
@end
