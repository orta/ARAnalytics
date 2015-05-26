#import <OCMock/OCMock.h>

#import "ORStubbedProvider.h"
#import <ARAnalytics/ARAnalytics.h>
#import <ARAnalytics/ARDSL.h>

@interface TestObject : NSObject
- (void)methodToBeExecuted;
- (void)methodToBeExecutedWithProperties;
- (void)methodToBeSkipped;
- (void)methodToNotBeSkipped;
- (void)appearedMethod;
@end

@implementation TestObject
// Do nothing, for hooking into
- (void)methodToBeExecuted {}
- (void)methodToBeExecutedWithProperties {}
- (void)methodToBeSkipped {}
- (void)methodToNotBeSkipped {}
- (void)appearedMethod {}
@end

@interface ARAnalytics (Testing)

+ (void)addEventAnalyticsHook:(NSDictionary *)eventDictionary;
+ (void)addScreenMonitoringAnalyticsHook:(NSDictionary *)screenDictionary;

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
            // We don't want to have ARAnalytics actually get set up.
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
            }] addEventAnalyticsHook:OCMArg.any];

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
    __block NSString * event;
    __block id analyticsMock;

    beforeEach(^{
        event = [[NSUUID UUID] UUIDString];
        analyticsMock = [OCMockObject mockForClass:ARAnalytics.class];
    });

    afterEach(^{
        [analyticsMock verify];
        [analyticsMock stopMocking];
    });

    it(@"calls the event method on ARAnalytics after the method", ^{
        [[analyticsMock expect] event:event withProperties:OCMOCK_ANY];
        
        [ARAnalytics addEventAnalyticsHook: @{
            ARAnalyticsClass: TestObject.class,
            ARAnalyticsDetails: @[@{
                ARAnalyticsEventName: event,
                ARAnalyticsSelectorName: ARAnalyticsSelector(methodToBeExecuted),
            }]
        }];
        
        [[[TestObject alloc] init] methodToBeExecuted];
    });

    it(@"respects the properties given by ARAnalyticsEventProperties", ^{
        NSString *propertyKey = @"airplanes";

        [[analyticsMock expect] event:event withProperties:[OCMArg checkWithBlock:^BOOL(NSDictionary *properties) {
            return properties[propertyKey] != nil;
        }]];

        [ARAnalytics addEventAnalyticsHook: @{
            ARAnalyticsClass: TestObject.class,
            ARAnalyticsDetails: @[ @{
                ARAnalyticsEventName: event,
                ARAnalyticsSelectorName: ARAnalyticsSelector(methodToBeExecutedWithProperties),
                ARAnalyticsProperties: ^NSDictionary *(TestObject *object, NSArray *arguments) {
                    return @{ propertyKey : @"Oh yeah" };
                }
            }]
        }];

        [[[TestObject alloc] init] methodToBeExecutedWithProperties];
    });

    describe(@"should fire", ^{
        __block BOOL didCheck;

        beforeEach(^{
            didCheck = NO;
        });

        afterEach(^{
            expect(didCheck).to.beTruthy();
        });

        it(@"skips event when shouldFire = NO", ^{
            [[analyticsMock reject] event:event withProperties:OCMOCK_ANY];
            
            [ARAnalytics addEventAnalyticsHook: @{
                ARAnalyticsClass: TestObject.class,
                ARAnalyticsDetails: @[ @{
                    ARAnalyticsEventName: event,
                    ARAnalyticsSelectorName: ARAnalyticsSelector(methodToBeSkipped),
                    ARAnalyticsShouldFire: ^BOOL(id o, NSArray *_) {
                        didCheck = YES;
                        return NO;
                    }
                }]
            }];
            
            [[[TestObject alloc] init] methodToBeSkipped];
        });

        it(@"fires event when shouldFire = YES", ^{
            [[analyticsMock expect] event:event withProperties:OCMOCK_ANY];

            [ARAnalytics addEventAnalyticsHook: @{
                ARAnalyticsClass: TestObject.class,
                ARAnalyticsDetails: @[ @{
                    ARAnalyticsEventName: event,
                    ARAnalyticsSelectorName: ARAnalyticsSelector(methodToNotBeSkipped),
                    ARAnalyticsShouldFire: ^BOOL(id o, NSArray *_) {
                        didCheck = YES;
                        return YES;
                    }
                }]
            }];

            [[[TestObject alloc] init] methodToNotBeSkipped];
        });

    });
});

describe(@"tracking screens", ^{
    __block ORStubbedProvider *provider = nil;

    beforeEach(^{
        provider = [[ORStubbedProvider alloc] init];
        [ARAnalytics setupProvider:provider];
    });

    afterEach(^{
        [ARAnalytics removeProvider:provider];
    });

    it(@"tracks page views without properties", ^{
        [ARAnalytics addScreenMonitoringAnalyticsHook: @{
            ARAnalyticsClass: TestObject.class,
            ARAnalyticsDetails: @[ @{
                ARAnalyticsPageName: @"page",
                ARAnalyticsSelectorName: ARAnalyticsSelector(appearedMethod),
            }]
        }];
        
        [[[TestObject alloc] init] appearedMethod];

        expect(provider.lastEventName).to.equal(@"Screen view");
        expect(provider.lastEventProperties).to.equal(@{ @"screen": @"page"});
    });

    it(@"tracks page views with properties", ^{
        [ARAnalytics addScreenMonitoringAnalyticsHook: @{
            ARAnalyticsClass: TestObject.class,
            ARAnalyticsDetails: @[ @{
                ARAnalyticsPageName: @"page",
                ARAnalyticsSelectorName: ARAnalyticsSelector(appearedMethod),
                ARAnalyticsProperties: ^NSDictionary *(TestObject *object, NSArray *arguments) {
                    return @{ @"airplanes": @"Oh yeah" };
                }
            }]
        }];
        
        [[[TestObject alloc] init] appearedMethod];

        expect(provider.lastEventName).to.equal(@"Screen view");
        expect(provider.lastEventProperties).to.equal(@{ @"airplanes": @"Oh yeah", @"screen": @"page"});
    });
});

SpecEnd
