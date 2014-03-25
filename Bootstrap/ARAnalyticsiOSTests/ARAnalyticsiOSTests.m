//
//  ARAnalyticsiOSTests.m
//  ARAnalyticsiOSTests
//
//  Created by Orta on 3/25/14.
//  Copyright (c) 2014 Orta Therox. All rights reserved.
//

#import "ORStubbedProvider.h"
#import <ARAnalytics/ARAnalytics.h>

SpecBegin(ARAnalyticsTests)


describe(@"Provider Init", ^{
    
    it(@"creates an instance with a known id", ^{
        NSString *identifier = @"asjdbaslfjdsbfj";
        ORStubbedProvider *provider = [[ORStubbedProvider alloc] initWithIdentifier:identifier];
        expect(provider.lastProviderIdentifier).to.equal(identifier);
    });
    
});

describe(@"ARAnalytics Providers", ^{
    it(@"Starts with no providers", ^{
        expect([ARAnalytics currentProviders].count).to.equal(0);
    });
    
    it(@"Adds a provider using setupProvider:", ^{
        ORStubbedProvider *provider = [[ORStubbedProvider alloc] init];
        [ARAnalytics setupProvider:provider];
        expect([ARAnalytics currentProviders]).to.contain(provider);
        expect([ARAnalytics currentProviders].count).to.equal(1);
        
        // Think this is a bit of an anti-pattern...
        // Perhaps a reset/clear function?
        [ARAnalytics removeProvider:provider];
    });
    
    it(@"Removes a provider using removeProvider:", ^{
        ORStubbedProvider *provider = [[ORStubbedProvider alloc] init];
        [ARAnalytics setupProvider:provider];
        [ARAnalytics removeProvider:provider];
        
        expect([ARAnalytics currentProviders]).toNot.contain(provider);
        expect([ARAnalytics currentProviders].count).to.equal(0);
    });
});


describe(@"ARAnalytics API", ^{
    __block ORStubbedProvider *provider = nil;
    
    beforeEach(^{
        if(provider) [ARAnalytics removeProvider:provider];
        
        provider = [[ORStubbedProvider alloc] init];
        [ARAnalytics setupProvider:provider];
    });
    
    
    describe(@"User Properties", ^{
        it(@"provider reacts to identifyUserWithID:andEmailAddress:", ^{
            NSString *userID = @"danger mcshane", *email = @"dm@gm.com";
            
            [ARAnalytics identifyUserWithID:userID andEmailAddress:email];
            
            expect(provider.email).to.equal(email);
            expect(provider.identifier).to.equal(userID);
        });
        
        it(@"provider reacts to setUserProperty:toValue:", ^{
            NSString *key = @"hair", *property = @"long";

            [ARAnalytics setUserProperty:key toValue:property];
            
            expect(provider.lastUserPropertyKey).to.equal(key);
            expect(provider.lastUserPropertyValue).to.equal(property);
        });
        
        it(@"provider reacts to incrementUserProperty:byInt:", ^{
            NSString *key = @"cm";
            NSInteger countAmount = 26;
            
            [ARAnalytics incrementUserProperty:key byInt:countAmount];
            
            expect(provider.lastUserPropertyKey).to.equal(key);
            expect(provider.lastUserPropertyCount).to.equal(countAmount);
            
            [ARAnalytics incrementUserProperty:key byInt:countAmount];
            expect(provider.lastUserPropertyCount).to.equal(countAmount * 2);
        });
    });
    
    describe(@"Events", ^{
        it(@"provider reacts to event:", ^{
            NSString *key = @"brush";
            [ARAnalytics event:key];
            
            expect(provider.lastEventName).to.equal(key);
        });
        
        it(@"provider reacts to event:withProperties:", ^{
            NSString *key = @"brush";
            NSDictionary *properties = @{ @"brush" : @"green" };
            [ARAnalytics event:key withProperties:properties];
            
            expect(provider.lastEventName).to.equal(key);
            expect(provider.lastEventProperties).to.equal(properties);
        });
    });
    
    describe(@"Errors", ^{
        it(@"provider reacts to error:", ^{
            NSError *error = [NSError errorWithDomain:@"io.orta.github.tangle" code:23 userInfo:@{}];
            [ARAnalytics error:error];
            
            expect(provider.lastError).to.equal(error);
        });
        
        it(@"provider reacts to error:withMessage:", ^{
            NSError *error = [NSError errorWithDomain:@"io.orta.github.tangle" code:23 userInfo:@{}];
            NSString *message = @"Tangle Alert";
            [ARAnalytics error:error withMessage:message];
            
            expect(provider.lastError).to.equal(error);
            expect(provider.lastErrorMessage).to.equal(message);
        });
    });
    
    describe(@"Navigation Controller", ^{
        it(@"provider reacts to pageView:", ^{
            NSString *key = @"straightener";
            [ARAnalytics pageView:key];
            
            expect(provider.lastLookedAtPagetitle).to.equal(key);
        });
    });
    
    describe(@"Timing", ^{
        it(@"provider reacts to a timing event", ^{
            NSString *event = @"curler";
            [ARAnalytics startTimingEvent:event];
            [ARAnalytics finishTimingEvent:event];
            expect(provider.lastEventName).to.equal(event);
        });
        
        it(@"provider reacts to a timing event with properties", ^{
            NSString *event = @"curler 2";
            NSDictionary *properties = @{ @"make" : @"ghd" };
            [ARAnalytics startTimingEvent:event];
            [ARAnalytics finishTimingEvent:event withProperties:properties];
            expect(provider.lastEventName).to.equal(event);
            expect(provider.lastEventProperties).to.equal(properties);
        });
        
        // Not sure what's going on here, the NSAssert is being called
        // but the expectation of any exception isn't being registered
        
        xit(@"is smart about adding the length to properties", ^{
            NSString *event = @"curler 2";
            NSDictionary *properties = @{ @"length" : @"122" };
            [ARAnalytics startTimingEvent:event];
            expect(^{
                [ARAnalytics finishTimingEvent:event withProperties:properties];
            }).to.raise(nil);
        });
    });
    
    describe(@"Logging", ^{
        it(@"Using ARLog submits it to our provider", ^{
            NSString *event = @"Time to go";
            ARLog(@"%@", event);
            expect(provider.lastRemoteLog).to.equal(event);
        });
    });
});

//
//    xit(@"provider reacts to monitorNavigationController:", ^{
//        UINavigationController *controller = [[UINavigationController alloc] init];
//        [ARAnalytics monitorNavigationController:controller];
//        
//        expect(provider.lastMonitoredNavigationController).to.equal(controller);
//    });

SpecEnd