#import "AdobeProvider.h"
#import "ARAnalyticsProviders.h"
#import "ADBMobile.h"

@interface AdobeProvider ()
/**
 * The default implementation for this provider is to track screens "-trackAction:data:" calls when they contain
 * custom key/value properties in addition to the pageTitle. By setting this property to YES, the Adobe Provider
 * will call "-trackState:data:" for page views that contain additional custom properties.
 *
 * The default value is NO.
 */
@property (nonatomic) BOOL callsTrackStateForPageViewsWithProperties;
@end

NSString const *AdobeProviderCallsTrackStateForPageViewsWithProperties = @"callsTrackStateForPageViewsWithProperties";

@implementation AdobeProvider
#ifdef AR_ADOBE_EXISTS

- (instancetype)initWithData:(NSDictionary *)additionalData {
    return [self initWithData:additionalData settings:nil];
}

- (instancetype)initWithData:(NSDictionary *)additionalData settings:(NSDictionary*)settings {
    NSAssert([ADBMobile class], @"Adobe is not included");
    if(additionalData) {
        [ADBMobile collectLifecycleDataWithAdditionalData:additionalData];
    } else {
        [ADBMobile collectLifecycleData];
    }

    self = [super init];
    if (self) {
        self.callsTrackStateForPageViewsWithProperties = [settings[AdobeProviderCallsTrackStateForPageViewsWithProperties] boolValue];
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
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

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {
    if (self.callsTrackStateForPageViewsWithProperties) {
        [ADBMobile trackState:pageTitle
                        data:properties];
    } else {
        [super didShowNewPageView:pageTitle withProperties:properties];
    }
}


#endif
@end
