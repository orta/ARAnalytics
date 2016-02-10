#import <ARAnalytics/ARAnalytics.h>
#import <OCMock/OCMock.h>
#import "AdobeProvider.h"
#import "ADBMobile.h"

SpecBegin(AdobeProviderTests)

    describe(@"Adobe Providers", ^{

        __block id adbMobileMock = nil;

        beforeEach(^{
            adbMobileMock = OCMClassMock([ADBMobile class]);
            OCMStub([adbMobileMock collectLifecycleData]);
            OCMStub([adbMobileMock collectLifecycleDataWithAdditionalData:[OCMArg any]]);
        });

        afterEach(^{
            [adbMobileMock stopMocking];
        });

        it(@"Adds an Adobe provider with the default settings", ^{
            AdobeProvider *provider = [[AdobeProvider alloc] initWithData:@{}];
            [ARAnalytics setupProvider:provider];
            expect([ARAnalytics currentProviders]).to.contain(provider);
        });

        it(@"Calls -trackState:data: for pageViews with no additional parameters", ^{
            [[adbMobileMock reject] trackAction:[OCMArg any] data:[OCMArg any]];

            AdobeProvider *provider = [[AdobeProvider alloc] initWithData:@{}];
            [ARAnalytics setupProvider:provider];

            [provider didShowNewPageView:@"page one"];
            OCMVerify([adbMobileMock trackState:@"page one" data:[OCMArg isNil]]);
        });

        it(@"Calls -trackAction:data: for pageViews with additional parameters", ^{
            [[adbMobileMock reject] trackState:[OCMArg any] data:[OCMArg any]];

            AdobeProvider *provider = [[AdobeProvider alloc] initWithData:@{}];
            [ARAnalytics setupProvider:provider];

            [provider didShowNewPageView:@"page one" withProperties:@{@"color" : @"blue"}];
            OCMVerify([adbMobileMock trackAction:@"Screen view" data:[OCMArg any]]);
        });

        it(@"Calls -trackState:data: for pageViews with additional parameters when configured to do so", ^{
            [[adbMobileMock reject] trackAction:[OCMArg any] data:[OCMArg any]];

            AdobeProvider *provider = [[AdobeProvider alloc] initWithData:@{} settings:@{
                    AdobeProviderCallsTrackStateForPageViewsWithProperties : @YES
            }];
            [ARAnalytics setupProvider:provider];

            [provider didShowNewPageView:@"page one" withProperties:@{@"color" : @"blue"}];
            OCMVerify([adbMobileMock trackState:@"page one" data:[OCMArg isNotNil]]);
        });

    });

SpecEnd