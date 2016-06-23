#import "YandexMobileMetricaProvider.h"

#ifdef AR_YANDEXMOBILEMETRICA_EXISTS
#import <YandexMobileMetrica/YandexMobileMetrica.h>
#endif

@implementation YandexMobileMetricaProvider
#ifdef AR_YANDEXMOBILEMETRICA_EXISTS

- (instancetype)initWithIdentifier:(NSString *)identifier {
    NSAssert([YMMYandexMetrica class], @"Yandex Mobile Metrica is not included");
    self = [super init];
    if (self != nil) {
#if YMM_VERSION_MAJOR < 2
#error This version of ARAnalytics uses YandexMobileMetrica version 2.0.0 and higher. \
Please update YandexMobileMetrica and your API key. \
For more information about new versions please visit: \
https://tech.yandex.com/metrica-mobile-sdk/doc/mobile-sdk-dg/concepts/ios-history-docpage/
#else
        [YMMYandexMetrica activateWithApiKey:identifier];
#endif
    }
    return self;
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
    [YMMYandexMetrica setEnvironmentValue:value forKey:property];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    [YMMYandexMetrica reportEvent:event parameters:properties onFailure:nil];
}

- (void)error:(NSError *)error withMessage:(NSString *)message {
	NSAssert(error, @"NSError instance has to be supplied");
	
    NSString *errorName = [NSString stringWithFormat:@"Error #%i", (int)error.code];
    NSException *exception = [NSException exceptionWithName:errorName
                                                     reason:error.localizedFailureReason
                                                   userInfo:@{ @"NSError" : error }];

    [YMMYandexMetrica reportError:message exception:exception onFailure:nil];
}

#endif
@end
