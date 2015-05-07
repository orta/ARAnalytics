#import <Foundation/Foundation.h>
#import "ARAnalyticalProvider.h"

#import <objc/runtime.h>
#import <asl.h>
#import <sys/stat.h>

static NSString *const ARTimingEventLengthKey = @"length";

@interface ARAnalyticalProvider () {
    aslclient _ASLClient;
    dispatch_queue_t _loggingQueue;
    NSString *_logFacility;
}
@end

@implementation ARAnalyticalProvider

- (id)initWithIdentifier:(NSString *)identifier {
    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {}
- (void)setUserProperty:(NSString *)property toValue:(NSString *)value {}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {}
- (void)incrementUserProperty:(NSString *)counterName byInt:(NSNumber *)amount {}

- (void)error:(NSError *)error withMessage:(NSString *)message {
	NSAssert(error, @"NSError instance has to be supplied");
	if(!message){
	   message = (error.localizedFailureReason) ? error.localizedFailureReason : @"Error";
	}
	
	NSString *empty = @"(empty)";
	[self event:message withProperties:@{
		@"failureReason" : (error.localizedFailureReason) ? error.localizedFailureReason : empty,
		@"description" : (error.localizedDescription) ? error.localizedDescription : empty,
		@"recoverySuggestion" : (error.localizedRecoverySuggestion) ? error.localizedRecoverySuggestion : empty,
		@"recoveryOptions" : ([error.localizedRecoveryOptions isKindOfClass:NSArray.class]) ? [error.localizedRecoveryOptions componentsJoinedByString:@", "] : empty
	}];
}

- (void)monitorNavigationViewController:(UINavigationController *)controller {}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval {
    [self logTimingEvent:event withInterval:interval properties:nil];
}

- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval properties:(NSDictionary *)properties {
    
    if (properties[ARTimingEventLengthKey]) {
        NSString *warning = [NSString stringWithFormat:@"Properties for timing event '%@' contains a key that clashes with the key used for reporting the length: %@", event, ARTimingEventLengthKey];
        NSLog(@"%@", warning);
        NSAssert(properties[ARTimingEventLengthKey], @"%@", warning);
    }
    
    NSMutableDictionary *mutableProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
    mutableProperties[ARTimingEventLengthKey] = interval;
    
    [self event:event withProperties:mutableProperties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [self event:@"Screen view" withProperties:@{ @"screen": pageTitle }];
}

- (void)remoteLog:(NSString *)parsedString {}

#pragma mark - Local Persisted Logging

// While it's highly unlikely that a provider will ever be released during the lifetime of an application,
// let's do the right thing anyways.
- (void)dealloc;
{
    if (_ASLClient != NULL) {
        asl_close(_ASLClient);
    }
}

- (NSString *)logFacility;
{
    @synchronized(self) {
        if (_logFacility == nil) {
            _logFacility = [NSString stringWithFormat:@"ARAnalytics-%s", class_getName(self.class)];
        }
    }
    return _logFacility;
}

- (dispatch_queue_t)loggingQueue;
{
    @synchronized(self) {
        if (_loggingQueue == NULL) {
            NSString *name = [NSString stringWithFormat:@"net.artsy.%@", self.logFacility];
            _loggingQueue = dispatch_queue_create(name.UTF8String, DISPATCH_QUEUE_SERIAL);
        }
    }
    return _loggingQueue;
}

// No need to synchronize access, but it should only be accessed from the `loggingQueue`.
- (aslclient)ASLClient;
{
    if (_ASLClient == NULL) {
        _ASLClient = asl_open(NULL, self.logFacility.UTF8String, 0);
        NSAssert(_ASLClient != NULL, @"Unable to create ASL client.");

        // Generates a warning because the macro uses just 1 instead of 1UL.
        //
        //     asl_set_filter(_ASLClient, ASL_FILTER_MASK_UPTO(ASL_FILTER_MASK_DEBUG));
        //
        // For now we're just using the default ‘debug’ level for all log messages, so this filter is enough.
        asl_set_filter(_ASLClient, ASL_FILTER_MASK_DEBUG);
    }
    return _ASLClient;
}

- (void)localLog:(NSString *)message;
{
    dispatch_async(self.loggingQueue, ^{
        aslmsg msg = asl_new(ASL_TYPE_MSG);
        asl_set(msg, ASL_KEY_MSG, message.UTF8String);
        asl_set(msg, ASL_KEY_FACILITY, self.logFacility.UTF8String);
        NSAssert(asl_send(self.ASLClient, msg) == 0, @"Unable to send log message.");
        asl_free(msg);
    });
}

- (NSArray *)messagesForProcessID:(NSUInteger)processID;
{
    NSMutableArray *messages = [NSMutableArray new];
    dispatch_sync(self.loggingQueue, ^{
        char pid[6];
        sprintf(pid, "%lu", processID);

        aslmsg query = asl_new(ASL_TYPE_QUERY);
        asl_set_query(query, ASL_KEY_FACILITY, self.logFacility.UTF8String, ASL_QUERY_OP_EQUAL);
        asl_set_query(query, ASL_KEY_PID, pid, ASL_QUERY_OP_EQUAL);

        aslresponse response = asl_search(self.ASLClient, query);
        if (response != NULL) {
            aslmsg message = NULL;
            while ((message = asl_next(response)) != NULL) {
                [messages addObject:[NSString stringWithUTF8String:asl_get(message, ASL_KEY_MSG)]];
            }
            asl_release(response);
        }
        asl_free(query);
    });
    return [messages copy];
}

@end
