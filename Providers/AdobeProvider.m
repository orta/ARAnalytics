#import "AdobeProvider.h"
#import "ARAnalyticsProviders.h"
#import "ADBMobile.h"

@implementation AdobeProvider
#ifdef AR_ADOBE_EXISTS

- (id)initWithData:(NSDictionary *)additionalData {
    NSAssert([ADBMobile class], @"Adobe is not included");
    if(additionalData) {
        [ADBMobile collectLifecycleDataWithAdditionalData:additionalData];
    } else {
        [ADBMobile collectLifecycleData];
    }

    return [super init];
}

- (id)initWithIdentifier:(NSString *)identifier
{
	return [self initWithData:nil];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [ADBMobile trackAction:event
                      data:properties];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [ADBMobile trackState:pageTitle
                     data:nil];
}

#endif
@end
