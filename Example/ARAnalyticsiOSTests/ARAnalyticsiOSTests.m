//
//  ARAnalyticsiOSTests.m
//  ARAnalyticsiOSTests
//
//  Created by Orta on 3/25/14.
//  Copyright (c) 2014 Orta Therox. All rights reserved.
//

#import "ORStubbedProvider.h"
#import <ARAnalytics/ARAnalytics.h>
#import <asl.h>

@interface ARAnalyticalProvider (Private)
- (dispatch_queue_t)loggingQueue;
- (NSString *)logFacility;
@end

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
        provider = [[ORStubbedProvider alloc] init];
        [ARAnalytics setupProvider:provider];
    });
    
    afterEach(^{
        [ARAnalytics removeProvider:provider];
        [ARAnalytics removeEventSuperProperty:@"paint"];
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

        it(@"send super properties", ^{
            NSString *key = @"brush";
            NSDictionary *properties = @{ @"brush" : @"green" };
            NSDictionary *supers = @{ @"paint" : @"blue" };

            [ARAnalytics addEventSuperProperties:supers];
            [ARAnalytics event:key withProperties:properties];

            expect(provider.lastEventProperties.allKeys.count).to.equal(2);
        });

        it(@"removes super properties", ^{
            NSString *key = @"brush";
            NSDictionary *properties = @{ @"brush" : @"green" };
            NSDictionary *supers = @{ @"paint" : @"blue" };

            [ARAnalytics addEventSuperProperties:supers];
            [ARAnalytics removeEventSuperProperty:@"paint"];

            [ARAnalytics event:key withProperties:properties];

            expect(provider.lastEventProperties.allKeys.count).to.equal(1);

            [ARAnalytics addEventSuperProperties:supers];
            [ARAnalytics removeEventSuperProperties:@[@"paint"]];
            expect(provider.lastEventProperties.allKeys.count).to.equal(1);
        });

    });

    describe(@"Screen views", ^{
        it(@"sends a screen view event", ^{
            [ARAnalytics pageView:@"home"];
            expect(provider.lastEventName).to.equal(@"Screen view");
            expect(provider.lastEventProperties).to.equal(@{ @"screen":@"home" });
        });

        it(@"sends a screen view event with extra properties", ^{
            [ARAnalytics pageView:@"home" withProperties:@{ @"alone":@YES }];
            expect(provider.lastEventName).to.equal(@"Screen view");
            expect(provider.lastEventProperties).to.equal(@{ @"screen":@"home", @"alone":@YES });
        });

        describe(@"super properties", ^{
            beforeEach(^{
                NSDictionary *supers = @{ @"paint": @"blue" };
                [ARAnalytics addEventSuperProperties:supers];
            });

            afterEach(^{
                [ARAnalytics removeEventSuperProperties:@[@"paint"]];
            });

            it(@"merges with super properties", ^{
                [ARAnalytics pageView:@"home"];
                expect(provider.lastEventName).to.equal(@"Screen view");
                expect(provider.lastEventProperties).to.equal(@{ @"screen": @"home", @"paint": @"blue" });
            });
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
            
            expect(provider.lastEventProperties).to.equal(@{ @"screen":key });
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

        it(@"persists log messages", ^{
            expect(provider.logFacility).to.equal(@"ARAnalytics-ORStubbedProvider");

            // First send the log message we want to find, to the same facility, but from a different PID.
            pid_t other_pid = fork();
            if (other_pid == 0) {
                char pid[128];
                sprintf(pid, "From other process (%d)", getpid());
                aslmsg msg = asl_new(ASL_TYPE_MSG);
                asl_set(msg, ASL_KEY_MSG, pid);
                asl_set(msg, ASL_KEY_LEVEL, ASL_STRING_EMERG);
                asl_set(msg, ASL_KEY_FACILITY, provider.logFacility.UTF8String);
                asl_send(NULL, msg);
                exit(0);
            }
            waitpid(other_pid, NULL, 0);

            // Now send the message we do *not* want to find from our current PID
            [provider localLog:[NSString stringWithFormat:@"From this process (%d)", getpid()]];
            dispatch_sync(provider.loggingQueue, ^{}); // wait till logging is performed

            NSArray *messages = nil;

            // Give ASL some time to flush all the pipes.
            float step = 0.1;
            float timeout = 5;
            while ((messages = [provider messagesForProcessID:(NSUInteger)other_pid]) &&
                    messages.count == 0 && timeout > 0) {
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, step, false);
                timeout -= step;
            }

            expect(messages.count).to.equal(1);
            expect(messages[0]).to.endWith([NSString stringWithFormat:@"From other process (%d)", other_pid]);
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
