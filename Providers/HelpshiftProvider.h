//
//  HelpshiftProvider.h
//  ARAnalytics
//
//  Created by John Arnold on 23 April 2013.
//

#import "ARAnalyticalProvider.h"

@interface HelpshiftProvider : ARAnalyticalProvider

- (id)initWithAppID:(NSString *)appID domainName:(NSString *)domainName apiKey:(NSString *)apiKey;

@end

