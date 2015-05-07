#import "HockeyAppProvider.h"
#import <HockeySDK/HockeySDK.h>

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
    [self localLog:message];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [self localLog:[NSString stringWithFormat:@"[%@] %@", event, properties]];
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
    NSUInteger processID = crashManager.lastSessionCrashDetails.appProcessIdentifier;
    NSArray *messages = [self messagesForProcessID:processID];
    return [messages componentsJoinedByString:@"\n"];
}

@end
