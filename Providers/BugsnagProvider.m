#import "BugsnagProvider.h"
#import "Bugsnag.h"

@implementation BugsnagProvider
#ifdef AR_BUGSNAP_EXISTS

- (instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([Bugsnag class], @"Bugsnag is not included");
    [Bugsnag startBugsnagWithApiKey:identifier];

    return [super init];
}

- (void)identifyUserwithID:(NSString *)userID andEmailAddress:(NSString *)email {
	if (userID) {
        [Bugsnag instance].userId = userID;
    }

    if (email) {
    	[Bugsnag setUserAttribute:@"email" withValue:email];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
    [Bugsnag setUserAttribute:property withValue:value];
}

#endif
@end
