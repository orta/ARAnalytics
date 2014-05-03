//
//  ARAnalyticsDSLTests.m
//  ARAnalyticsTests
//
//  Created by Ash Furrow on 2014-05-02.
//  Copyright (c) 2014 Orta Therox. All rights reserved.
//

#import <OCMock/OCMock.h>

#import <ARAnalytics/ARAnalytics.h>
#import <ARAnalytics/ARDSL.h>

@interface TestObject : NSObject

- (void)method;
- (void)method2;

@end

@implementation TestObject

- (void)method
{
    // Do nothing
}

- (void)method2
{
    // Do nothing
}

@end


SpecBegin(ARAnalyticsDSLTests)

it(@"calls super", ^{
    NSDictionary *dictionary = [NSDictionary dictionary];
    id classMock = [OCMockObject mockForClass:[ARAnalytics class]];
    [[classMock expect] setupWithAnalytics:dictionary];
    
    [ARAnalytics setupWithAnalytics:dictionary configuration:nil];
    
    [classMock verify];
    
    [classMock stopMocking];
});

describe(@"tracked screens", ^{
    it(@"effects a tracking page view", ^{
        id classMock = [OCMockObject mockForClass:[ARAnalytics class]];
        [[classMock expect] event:@"event" withProperties:nil];
        
        [ARAnalytics setupWithAnalytics:nil configuration:@{
            ARAnalyticsTrackedEvents: @[
                @{
                    ARAnalyticsClass: TestObject.class,
                    ARAnalyticsDetails: @[
                        @{
                            ARAnalyticsEventName: @"event",
                            ARAnalyticsSelectorName: @"method",
                        }
                    ]
                }
            ]
        }];
        
        [[[TestObject alloc] init] method];
        
        [classMock verify];
        [classMock stopMocking];
    });
    
    it(@"does not effect a tracking page view for shouldFire NO", ^{
        id classMock = [OCMockObject mockForClass:[ARAnalytics class]];
        [[classMock reject] event:@"event" withProperties:nil];
        
        [ARAnalytics setupWithAnalytics:nil configuration:@{
            ARAnalyticsTrackedEvents: @[
                @{
                    ARAnalyticsClass: TestObject.class,
                    ARAnalyticsDetails: @[
                        @{
                            ARAnalyticsEventName: @"event",
                            ARAnalyticsSelectorName: @"method2",
                            ARAnalyticsShouldFire: ^BOOL(id o, RACTuple *_) {
                                return NO;
                            }
                        }
                    ]
                }
            ]
        }];
        
        [[[TestObject alloc] init] method2];
        
        [classMock verify];
        [classMock stopMocking];
    });
});

describe(@"tracked events", ^{
    it(@"effects a tracking page view", ^{
        id classMock = [OCMockObject mockForClass:[ARAnalytics class]];
        [[classMock expect] pageView:@"page"];
        
        [ARAnalytics setupWithAnalytics:nil configuration:@{
            ARAnalyticsTrackedScreens: @[
                @{
                    ARAnalyticsClass: TestObject.class,
                    ARAnalyticsDetails: @[
                        @{
                            ARAnalyticsPageName: @"page",
                            ARAnalyticsSelectorName: @"method",
                        }
                    ]
                }
            ]
        }];
        
        [[[TestObject alloc] init] method];
        
        [classMock verify];
        [classMock stopMocking];
    });
});

SpecEnd