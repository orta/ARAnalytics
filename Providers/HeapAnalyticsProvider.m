//
//  HeapAnalyticsProvider.m
//  Pods
//
//  Created by Daniel Haight on 20/10/2013.
//
//

#import "HeapAnalyticsProvider.h"
#import "Heap.h"

@implementation HeapAnalyticsProvider

#ifdef AR_HEAPANALYTICS_EXISTS
-(id)initWithIdentifier:(id)identifier {
    NSAssert([Heap class], @"Heap is not included");
    [[Heap sharedInstance] setAppId:identifier];
    
    return [super init];
}



#endif
@end
