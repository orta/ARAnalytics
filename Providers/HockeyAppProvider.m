//
//  HockeyAppProvider.m
//  
//
//  Created by Daniel Haight on 16/08/2013.
//
//

#import "HockeyAppProvider.h"
#import <HockeySDK/HockeySDK.h>

@interface HockeyAppProvider () <BITHockeyManagerDelegate, BITUpdateManagerDelegate, BITCrashManagerDelegate>

@end

@implementation HockeyAppProvider

-(id)initWithIdentifier:(NSString *)identifier {
    return [self initWithBetaIdentifier:identifier liveIdentifier:nil];
}

-(id)initWithBetaIdentifier:(NSString *)betaIdentifier liveIdentifier:(NSString *)liveIdentfier {
    if (liveIdentfier) {
        [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:betaIdentifier liveIdentifier:liveIdentfier delegate:self];
    }
    else {
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:betaIdentifier delegate:self];
    }
    
    [[BITHockeyManager sharedHockeyManager] startManager];
    
    return [super init];
}

#pragma mark - BITUpdateManagerDelegate
- (NSString *)customDeviceIdentifierForUpdateManager:(BITUpdateManager *)updateManager {
#ifdef DEBUG
    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
        return [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
#endif
    return nil;
}

@end
