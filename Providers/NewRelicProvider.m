//
//  NewRelicProvider.m
//  Pods
//
//  Created by Daniel Haight on 01/08/2013.
//
//

#import "NewRelicProvider.h"
#import <NewRelicAgent/NewRelic.h>

@implementation NewRelicProvider

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([NewRelic class], @"NewRelic is not included");
    [NewRelic startWithApplicationToken:identifier];
    
    return [super init];
}

@end
