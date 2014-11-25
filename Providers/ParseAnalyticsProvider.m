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
    
    //Parse Docs reccomend calling trackAppOpenedWithLaunchOptions: on PFAnalytics in UIApplicationDelegate applicationDidFinishLaunchingWithOptions - the notification we subscribe to below is called once this returns
    
    //https://parse.com/docs/ios_guide#analytics/iOS
    
    //https://developer.apple.com/library/ios/documentation/uikit/reference/UIApplicationDelegate_Protocol/Reference/Reference.html#jumpTo_9
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    
    return [super init];
}

-(void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSString *formattedEvent=[self replacespacesWithUnderscore:event];
    if (properties) {
        //values must be strings
        //https://parse.com/docs/ios/api/Classes/PFAnalytics.html#//api/name/trackEvent:dimensions:
        //quick and dirty hack to ensure this
        
        NSMutableDictionary *dimensions = [NSMutableDictionary new];
        [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *formattedKey=[self replacespacesWithUnderscore:key];
            NSString *formattedDescription=[self replacespacesWithUnderscore:[obj description]];
            dimensions[formattedKey]=formattedDescription;
        }];
        
        [PFAnalytics trackEvent:formattedEvent dimensions:dimensions];
        
    }
    else {
        [PFAnalytics trackEvent:formattedEvent];
    }
}

-(NSString *)replacespacesWithUnderscore:(NSString *)input
{
    return [input stringByReplacingOccurrencesOfString:@" " withString:@"_"];
}

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
    //also in the apple developer docs link - the options passed into applicationDidFinishLaunchingWithOptions: are the sent in the userInfo object of the notification.
    [PFAnalytics trackAppOpenedWithLaunchOptions:notification.userInfo];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
}

@end
