//
//  ParseAnalyticsProvider.m
//  Pods
//
//  Created by Daniel Haight on 19/10/2013.
//
//

#import "ParseAnalyticsProvider.h"
#import "Parse.h"

@implementation ParseAnalyticsProvider

-(id)initWithApplicationID:(id)appID clientKey:(id)clientKey {
    NSAssert([Parse class], @"Parse is not included");
    
    [Parse setApplicationId:appID
                  clientKey:clientKey];
    
    return [super init];
}

@end
