#import "LaunchKitProvider.h"
#import <LaunchKit/LaunchKit.h>

@implementation LaunchKitProvider
#ifdef AR_LAUNCHKIT_EXISTS

-(instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([LaunchKit class], @"LaunchKit is not included");
    [LaunchKit launchWithToken:identifier];
    
    return [super init];
}

-(void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    [[LaunchKit sharedInstance] setUserIdentifier:userID
                                            email:email
                                             name:nil];
}

#endif
@end
