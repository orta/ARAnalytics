#import "ARAnalyticalProvider.h"

@interface KeenProvider : ARAnalyticalProvider

- (instancetype)initWithProjectId:(NSString *)projectId andWriteKey:(NSString *)writeKey andReadKey:(NSString *)readKey;

// ARAnalyticalProvider methods to implement in the future:
//- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email;
//- (void)setUserProperty:(NSString *)property toValue:(NSString *)value;
//- (void)event:(NSString *)event withProperties:(NSDictionary *)properties;
//- (void)incrementUserProperty:(NSString *)counterName byInt:(NSNumber *)amount;
//- (void)error:(NSError *)error withMessage:(NSString *)message;
//- (void)didShowNewViewController:(UIViewController *)controller;
//- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval;
//- (void)remoteLog:(NSString *)parsedString;

@end
