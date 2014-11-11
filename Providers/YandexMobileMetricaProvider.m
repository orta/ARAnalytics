//
//  YandexMobileMetricaProvider.m
//  ARAnalyticsTests
//
//  Created by Nikolay Volosatov on 31/10/2014.
//  
//

#import "YandexMobileMetricaProvider.h"

#ifdef AR_YANDEXMOBILEMETRICA_EXISTS
#import "YandexMobileMetrica.h"
#endif

@implementation YandexMobileMetricaProvider
#ifdef AR_YANDEXMOBILEMETRICA_EXISTS

- (id)initWithIdentifier:(NSString *)identifier {
    NSAssert([YMMYandexMetrica class], @"Yandex Mobile Metrica is not included");
    [YMMYandexMetrica startWithAPIKey:identifier];

    return [super init];
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
