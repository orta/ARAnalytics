//
//  TapstreamProvider.h
//  Pods
//
//  Created by Daniel Haight on 28/07/2013.
//
//

#import "ARAnalyticalProvider.h"
#import "TSTapstream.h"

@interface TapstreamProvider : ARAnalyticalProvider

- (id)initWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret;
- (id)initWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret config:(TSConfig *)config;

@end
