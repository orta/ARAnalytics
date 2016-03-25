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
        analyticsMock = OCMClassMock([ARAnalytics class]);
    });

    afterEach(^{
        [analyticsMock stopMocking];
    });

    it(@"calls the event method on ARAnalytics after the method", ^{
        [ARAnalytics addEventAnalyticsHook: @{
            ARAnalyticsClass: TestObject.class,
            ARAnalyticsDetails: @[@{
                ARAnalyticsEventName: event,
                ARAnalyticsSelectorName: ARAnalyticsSelector(methodToBeExecuted),
            }]
        }];

        [[[TestObject alloc] init] methodToBeExecuted];

        OCMVerify([analyticsMock event:event withProperties:[OCMArg any]]);
    });

    it(@"calls the event method on ARAnalytics after the method when the event name is supplied via a block", ^{
        [ARAnalytics addEventAnalyticsHook:@{
                ARAnalyticsClass : TestObject.class,
                ARAnalyticsDetails : @[@{
                        ARAnalyticsEventNameBlock : ^NSString *(TestObject *controller,
                                NSArray *parameters, NSDictionary *customProperties) {
                            return event;
                        },
                        ARAnalyticsSelectorName : ARAnalyticsSelector(methodToBeExecuted),
                }]
        }];

        [[[TestObject alloc] init] methodToBeExecuted];

        OCMVerify([analyticsMock event:event withProperties:[OCMArg any]]);
    });
    
    it(@"only calls the block to extract properties once", ^{
        __block NSInteger timesCalled = 0;
        [ARAnalytics addEventAnalyticsHook:@{
                ARAnalyticsClass : TestObject.class,
                ARAnalyticsDetails : @[@{
                       ARAnalyticsProperties: ^NSDictionary*(TestObject *controller, NSArray *parameters) {
                            timesCalled++;
                            return @{};
                       },
                       ARAnalyticsEventNameBlock : ^NSString *(TestObject *controller,
                                                      NSArray *parameters, NSDictionary *customProperties) {
                            return event;
                       },
                       ARAnalyticsSelectorName : ARAnalyticsSelector(methodToBeExecuted),
                }]
        }];
        
        [[[TestObject alloc] init] methodToBeExecuted];
        
        OCMVerify([analyticsMock event:event withProperties:[OCMArg any]]);
        expect(timesCalled).to.equal(1);
    });

    it(@"respects the properties given by ARAnalyticsEventProperties", ^{
        NSString *propertyKey = @"airplanes";

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

        OCMVerify([analyticsMock event:event withProperties:[OCMArg checkWithBlock:^BOOL(NSDictionary *properties) {
            return properties[propertyKey] != nil;
        }]]);
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

            OCMVerifyAll(analyticsMock);
        });

        it(@"fires event when shouldFire = YES", ^{

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

            OCMVerify([analyticsMock event:event withProperties:OCMOCK_ANY]);
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

    it(@"tracks page views with the page name supplied from a block", ^{
        [ARAnalytics addScreenMonitoringAnalyticsHook: @{
            ARAnalyticsClass: TestObject.class,
            ARAnalyticsDetails: @[ @{
                ARAnalyticsPageNameBlock: ^NSString *(UIViewController *controller, NSArray *parameters,
                                                    NSDictionary *customProperties) {
                            return @"page";
                },
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
