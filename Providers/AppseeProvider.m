#import "AppseeProvider.h"
#import <Appsee/Appsee.h>

@implementation AppseeProvider
#ifdef AR_APPSEE_EXISTS

-(instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([Appsee class], @"Appsee is not included");
    [Appsee start:identifier];
    
    return [super init];
}

-(void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [Appsee setUserID:userID];
    }
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {
    [Appsee startScreen:pageTitle];
}

-(void)event:(NSString *)event withProperties:(NSDictionary *)properties {
	[Appsee addEvent:event withProperties:properties];
}

#endif
@end
