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
- (void)method1;
- (void)method2;
@end

@implementation TestObject
// Do nothing, for hooking into
- (void)method1 {}
- (void)method2 {}
@end


SpecBegin(ARAnalyticsDSLTests)

describe(@"setup with configuration", ^{
    it(@"calls super", ^{
        NSDictionary *dictionary = [NSDictionary dictionary];
        id classMock = [OCMockObject mockForClass:ARAnalytics.class];
        [[classMock expect] setupWithAnalytics:dictionary];
        
        [ARAnalytics setupWithAnalytics:dictionary configuration:nil];
        
        [classMock verify];
        [classMock stopMocking];
    });

    describe(@"configuration dictionary", ^{
        __block id analyticsMock;

        beforeEach(^{
            // We don't want to have ARAnalytics get set up.
            analyticsMock = [OCMockObject mockForClass:ARAnalytics.class];
            [[analyticsMock stub] setupWithAnalytics:OCMArg.any];
        });

        afterEach(^{
            [analyticsMock verify];
            [analyticsMock stopMocking];
        });

        it(@"passes tracked events through", ^{
            __block NSInteger invocationCount = 0;

            [[[analyticsMock stub] andDo:^(NSInvocation *invocation) {
                invocationCount++;
            }] addEventAnalyticsHooks:OCMArg.any];

            [ARAnalytics setupWithAnalytics:nil configuration:@{
                ARAnalyticsTrackedEvents: @[ @{}, @{} ]
            }];

            expect(invocationCount).to.equal(2);
        });

        it(@"passes screen events through", ^{
            __block NSInteger invocationCount = 0;

            [[[analyticsMock stub] andDo:^(NSInvocation *invocation) {
                invocationCount++;
            }] addScreenMonitoringAnalyticsHook:OCMArg.any];

            [ARAnalytics setupWithAnalytics:nil configuration:@{
                ARAnalyticsTrackedScreens: @[ @{}, @{} ]
            }];

            expect(invocationCount).to.equal(2);
        });
    });
});

describe(@"events", ^{

    __block NSString *selector1Name, *selector2Name;
    __block NSString *event1, *event2;
    __block id analyticsMock;

    beforeEach(^{
        analyticsMock = [OCMockObject mockForClass:ARAnalytics.class];

        selector1Name = NSStringFromSelector(@selector(method1));
        selector2Name = NSStringFromSelector(@selector(method2));

        event1 = @"event";
        event2 = @"event_has_properties";
    });

    afterEach(^{
        [analyticsMock verify];
        [analyticsMock stopMocking];

        [ARAnalytics removeAllAnalyticsHooks];
    });

    it(@"successfully removes all hooks", ^{

        [[analyticsMock expect] event:event1 withProperties:nil];

        [ARAnalytics addEventAnalyticsHooks: @{
            ARAnalyticsClass: TestObject.class,
            ARAnalyticsDetails: @[ @{
               ARAnalyticsEventName: event1,
               ARAnalyticsSelectorName: selector1Name,
            }]
        }];

        // Set it up to verify the event gets called

        [[[TestObject alloc] init] method1];
        [analyticsMock verify];
        [analyticsMock stopMocking];

        [ARAnalytics removeAllAnalyticsHooks];

        // Set it up a second time to verify it isn't called.

        id classMock2 = [OCMockObject mockForClass:ARAnalytics.class];
        [[classMock2 reject] event:event1 withProperties:nil];

        [[[TestObject alloc] init] method1];
    });

    it(@"calls the event method on ARAnalytics after the method", ^{
        [[analyticsMock expect] event:@"event" withProperties:nil];
        
        [ARAnalytics addEventAnalyticsHooks: @{
            ARAnalyticsClass: TestObject.class,
            ARAnalyticsDetails: @[ @{
                ARAnalyticsEventName: event1,
                ARAnalyticsSelectorName: selector1Name,
            }]
        }];
        
        [[[TestObject alloc] init] method1];
    });
    
    it(@"respects the properties given by ARAnalyticsEventProperties", ^{
        NSString *propertyKey = @"airplanes";

        [[analyticsMock expect] event:event2 withProperties:[OCMArg checkWithBlock:^BOOL(NSDictionary *properties) {
            return properties[propertyKey] != nil;
        }]];

        [ARAnalytics addEventAnalyticsHooks: @{
            ARAnalyticsClass: TestObject.class,
            ARAnalyticsDetails: @[ @{
                ARAnalyticsEventName: event2,
                ARAnalyticsSelectorName: selector1Name,
                ARAnalyticsEventProperties: ^ NSDictionary *(TestObject *object, NSArray *arguments) {
                    return @{ propertyKey : @"Oh yeah" };
                }
            }]
        }];

        [[[TestObject alloc] init] method1];
    });
    
    describe(@"should fire", ^{
        __block BOOL didFire = NO;

        beforeEach(^{
            didFire = NO;
        });

        afterEach(^{
            expect(didFire).to.beTruthy();
        });

        it(@"skips event when shouldFire = NO", ^{
            [[analyticsMock reject] event:event1 withProperties:nil];
            
            [ARAnalytics addEventAnalyticsHooks: @{
                ARAnalyticsClass: TestObject.class,
                ARAnalyticsDetails: @[ @{
                    ARAnalyticsEventName: event1,
                    ARAnalyticsSelectorName: selector2Name,
                    ARAnalyticsShouldFire: ^BOOL(id o, NSArray *_) {
                        didFire = YES;
                        return NO;
                    }
                }]
            }];
            
            [[[TestObject alloc] init] method2];
        });

        it(@"skips event when shouldFire = YES", ^{
            [[analyticsMock expect] event:event1 withProperties:nil];

            [ARAnalytics addEventAnalyticsHooks: @{
                ARAnalyticsClass: TestObject.class,
                ARAnalyticsDetails: @[ @{
                    ARAnalyticsEventName: event1,
                    ARAnalyticsSelectorName: selector2Name,
                    ARAnalyticsShouldFire: ^BOOL(id o, NSArray *_) {
                        didFire = YES;
                        return YES;
                    }
                }]
            }];

            [[[TestObject alloc] init] method2];
        });

    });
});

describe(@"tracking screens", ^{
    it(@"tracks page views", ^{
        id classMock = [OCMockObject mockForClass:[ARAnalytics class]];
        [[classMock expect] pageView:@"page"];
        
        [ARAnalytics addScreenMonitoringAnalyticsHook: @{
            ARAnalyticsClass: TestObject.class,
            ARAnalyticsDetails: @[ @{
                ARAnalyticsPageName: @"page",
                ARAnalyticsSelectorName: @"method1",
            }]
        }];
        
        [[[TestObject alloc] init] method1];
        
        [classMock verify];
        [classMock stopMocking];
    });
});

SpecEnd