//
//  CrashlyticsProvider.h
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import "ARAnalyticalProvider.h"

// Whilst we cannot include the Crashlytics library
// we can stub out the implementation with methods we want
// so that it will link with the real framework later on ./
#ifdef AR_CRASHLYTICS_EXISTS

@interface Crashlytics : NSObject
+ (Crashlytics *)startWithAPIKey:(NSString *)apiKey;
+ (void)setUserIdentifier:(NSString *)identifier;
+ (void)setUserName:(NSString *)name;
+ (void)setUserEmail:(NSString *)email;
+ (void)setObjectValue:(id)value forKey:(NSString *)key;
@end

OBJC_EXTERN void CLSLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

#endif


@interface CrashlyticsProvider : ARAnalyticalProvider
@end
