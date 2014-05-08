//
//  TapstreamProvider.m
//  Pods
//
//  Created by Daniel Haight on 28/07/2013.
//
//

#import "TapstreamProvider.h"
#import "TSTapstream.h"

@implementation TapstreamProvider

- (id)initWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret {
    return [self initWithAccountName:accountName developerSecret:developerSecret config:nil];
}

- (id)initWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret config:(TSConfig *)config {
    NSAssert([TSTapstream class], @"Tapstream is not included");
    if (!config) {
        config = [TSConfig configWithDefaults];
    }
    [TSTapstream createWithAccountName:accountName developerSecret:developerSecret config:config];
    
    return [super init];
}


- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    
    TSTapstream *tracker = [TSTapstream instance];
    
    TSEvent *tsEvent = [TSEvent eventWithName:event oneTimeOnly:NO];
    
    //iterate through properties, add them to event 'tsEvent'
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [tsEvent addValue:obj forKey:key];
    }];
     
    [tracker fireEvent:tsEvent];
    
}
@end
