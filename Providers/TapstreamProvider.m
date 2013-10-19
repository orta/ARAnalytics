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
        
        if ([obj isKindOfClass:[NSString class]]) {
            [tsEvent addValue:obj forKey:key];
        }
        else if ([obj isKindOfClass:[NSNumber class]]){
            if (strcmp([obj objCType], @encode(BOOL)) == 0) {
                [tsEvent addBooleanValue:[obj boolValue] forKey:key];
            }
            else if (strcmp([obj objCType], @encode(int)) == 0) {
                [tsEvent addBooleanValue:[obj intValue] forKey:key];
            }
            else if (strcmp([obj objCType], @encode(double)) == 0) {
                [tsEvent addBooleanValue:[obj doubleValue] forKey:key];
            }
            else {
                //only throw exception in debug mode, otherwise do nothing.
#ifdef DEBUG
                NSException *e = [NSException
                                  exceptionWithName:@"ARAnalyticsTapstreamNumberException"
                                  reason:[NSString stringWithFormat:@"*** Tapstream cannot send number of type: %s", [obj objCType]]
                                  userInfo:nil];
                @throw e;
#endif
            }
        }
        else {
            //only throw exception in debug mode, otherwise do nothing.
#ifdef DEBUG
            NSException *e = [NSException
                              exceptionWithName:@"ARAnalyticsTapstreamPropertyException"
                              reason:[NSString stringWithFormat:@"*** Tapstream cannot send parameters of type: %@", NSStringFromClass([obj class])]
                              userInfo:nil];
            @throw e;
#endif
        }
    }];
    
    [tracker fireEvent:tsEvent];
    
}
@end
