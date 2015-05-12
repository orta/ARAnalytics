#import "HockeyAppProvider.h"
#import <HockeySDK/HockeySDK.h>
#import <objc/message.h>

#define MAX_HOCKEY_LOG_MESSAGES 100

static BOOL
IsHockeySDKCompatibleForLogging(void)
{
    static dispatch_once_t onceToken = 0;
    static BOOL compatible = NO;
    dispatch_once(&onceToken, ^{
        compatible = [[BITCrashDetails class] instancesRespondToSelector:@selector(appProcessIdentifier)];
    });
    return compatible;
}

@interface HockeyAppProvider () <BITHockeyManagerDelegate, BITUpdateManagerDelegate, BITCrashManagerDelegate> {
    NSString *_username;
    NSString *_userEmail;
    NSString *_betaIdentifier;
    NSString *_liveIdentifier;
}

@end

@implementation HockeyAppProvider

-(id)initWithIdentifier:(NSString *)identifier {
    return [self initWithBetaIdentifier:identifier liveIdentifier:nil];
}

-(id)initWithBetaIdentifier:(NSString *)betaIdentifier liveIdentifier:(NSString *)liveIdentfier {
    self = [super init];
    if (!self) return nil;
    
    _betaIdentifier = betaIdentifier;
    _liveIdentifier = liveIdentfier;
    
    [self performSelector:@selector(startManager) withObject:nil afterDelay:0.5];
    
    return self;
}

-(void)startManager {
    if (_liveIdentifier) {
        [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:_betaIdentifier liveIdentifier:_liveIdentifier delegate:self];
    }
    else {
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:_betaIdentifier delegate:self];
    }
    
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
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

#pragma mark - BITUpdateManagerDelegate
- (NSString *)customDeviceIdentifierForUpdateManager:(BITUpdateManager *)updateManager {
#ifdef DEBUG

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)]){
        return [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
    }
#pragma clang diagnostic pop
    
#endif
    return nil;
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
    NSUInteger processID = ((NSUInteger (*)(id, SEL))objc_msgSend)(crashDetails, @selector(appProcessIdentifier));
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
