#import "HockeyAppOSXProvider.h"
#import <objc/message.h>

#ifdef AR_HOCKEYAPPOSX_EXISTS
#import <HockeySDK/HockeySDK.h>
#import <HockeySDK/BITCrashDetails.h>
#import <HockeySDK/BITCrashManager.h>
#import <HockeySDK/BITCrashManagerDelegate.h>
#endif

#define MAX_HOCKEY_LOG_MESSAGES 100

static BOOL
IsHockeySDKCompatibleForLogging(void)
{
    static dispatch_once_t onceToken = 0;
    static BOOL compatible = NO;
    dispatch_once(&onceToken, ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        compatible = [[BITCrashDetails class] instancesRespondToSelector:@selector(appProcessIdentifier)];
#pragma clang diagnostic pop
    });
    return compatible;
}

@interface HockeyAppOSXProvider () <BITHockeyManagerDelegate, BITCrashManagerDelegate> {
    NSString *_username;
    NSString *_userEmail;
    NSString *_liveIdentifier;
}

@end

@implementation HockeyAppOSXProvider

-(instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (!self) return nil;

    _liveIdentifier = identifier;

    [self performSelector:@selector(startManager) withObject:nil afterDelay:0.5];

    return self;
}

-(void)startManager {
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:_liveIdentifier delegate:self];

    [[BITHockeyManager sharedHockeyManager] startManager];
#if HOCKEYSDK_FEATURE_AUTHENTICATOR
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
#endif
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    _username = userID;
    _userEmail = email;
}

#pragma mark - Log breadcrumbs
- (void)remoteLog:(NSString *)message {
    if (IsHockeySDKCompatibleForLogging()) {
        [self localLog:message];
    }
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    if (IsHockeySDKCompatibleForLogging()) {
        [self localLog:[NSString stringWithFormat:@"[%@] %@", event, properties]];
    }
}

#pragma mark - BITHockeyManagerDelegate
- (NSString *)userNameForHockeyManager:(BITHockeyManager *)hockeyManager componentManager:(BITHockeyBaseManager *)componentManager {
    return _username;
}

-(NSString *)userEmailForHockeyManager:(BITHockeyManager *)hockeyManager componentManager:(BITHockeyBaseManager *)componentManager {
    return _userEmail;
}

#pragma mark - BITCrashManagerDelegate
- (NSString *)applicationLogForCrashManager:(BITCrashManager *)crashManager {
    if (!IsHockeySDKCompatibleForLogging()) {
        return @"";
    }

    BITCrashDetails *crashDetails = crashManager.lastSessionCrashDetails;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSUInteger processID = ((NSUInteger (*)(id, SEL))objc_msgSend)(crashDetails, @selector(appProcessIdentifier));
#pragma clang diagnostic pop

    if (processID == 0) {
        return @"";
    }

    NSArray *messages = [self messagesForProcessID:processID];
    NSUInteger count = messages.count;
    if (count > MAX_HOCKEY_LOG_MESSAGES) {
        messages = [messages subarrayWithRange:NSMakeRange(count-MAX_HOCKEY_LOG_MESSAGES, MAX_HOCKEY_LOG_MESSAGES)];
    }
    return [messages componentsJoinedByString:@"\n"];
}

@end
