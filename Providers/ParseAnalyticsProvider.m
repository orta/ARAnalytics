//
//  ARAnalyticalProvider.m
//  ARAnalytics
//

#import "ParseAnalyticsProvider.h"
#import <Parse/Parse.h>

@implementation ParseAnalyticsProvider

- (instancetype)initWithApplicationID:(NSString *)applicationId clientKey:(NSString *)clientKey {
    NSAssert([Parse class], @"Parse is not included");
    
    [Parse setApplicationId:applicationId clientKey:clientKey];
    
    return [super init];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSString *formattedEvent = [self replacespacesWithUnderscore:event];
    
    if (properties != nil) {
        //values must be strings
        //https://parse.com/docs/ios/api/Classes/PFAnalytics.html#//api/name/trackEvent:dimensions:
        //quick and dirty hack to ensure this
        
        NSMutableDictionary *dimensions = [NSMutableDictionary dictionary];
        
        [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *formattedKey = [self replacespacesWithUnderscore:key];
            NSString *formattedDescription = [self replacespacesWithUnderscore:[obj description]];
            
            dimensions[formattedKey] = formattedDescription;
        }];
        
        [PFAnalytics trackEvent:formattedEvent dimensions:dimensions];
    } else {
        [PFAnalytics trackEvent:formattedEvent];
    }
}

- (NSString *)replacespacesWithUnderscore:(NSString *)input {
    return [input stringByReplacingOccurrencesOfString:@" " withString:@"_"];
}

@end
