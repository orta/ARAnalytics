#import "FabricProvider.h"

@interface Crashlytics : NSObject
+ (Crashlytics *)sharedInstance;
- (void)setUserIdentifier:(NSString *)identifier;
- (void)setUserName:(NSString *)name;
- (void)setUserEmail:(NSString *)email;
- (void)setObjectValue:(id)value forKey:(NSString *)key;
- (void)recordError:(NSError *)error withAdditionalUserInfo:(NSDictionary *)userInfo;
@end

#ifndef ANS_GENERIC
#define ANS_GENERIC

#if !__has_feature(nullability)
#define nonnull
#define nullable
#define _Nullable
#define _Nonnull
#endif

#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN
#endif

#ifndef NS_ASSUME_NONNULL_END
#define NS_ASSUME_NONNULL_END
#endif

#if __has_feature(objc_generics)
#define ANS_GENERIC_NSARRAY(type) NSArray<type>
#define ANS_GENERIC_NSDICTIONARY(key_type,object_key) NSDictionary<key_type, object_key>
#else
#define ANS_GENERIC_NSARRAY(type) NSArray
#define ANS_GENERIC_NSDICTIONARY(key_type,object_key) NSDictionary
#endif

#endif

NS_ASSUME_NONNULL_BEGIN
@interface Answers : NSObject

+ (void)logContentViewWithName:(nullable NSString *)contentNameOrNil
                   contentType:(nullable NSString *)contentTypeOrNil
                     contentId:(nullable NSString *)contentIdOrNil
              customAttributes:(nullable ANS_GENERIC_NSDICTIONARY(NSString *, id) *)customAttributesOrNil;

+ (void)logCustomEventWithName:(NSString *)eventName
              customAttributes:(nullable ANS_GENERIC_NSDICTIONARY(NSString *, id) *)customAttributesOrNil;

@end
NS_ASSUME_NONNULL_END

@implementation FabricProvider
#ifdef AR_FABRIC_EXISTS

- (instancetype)initWithKits:(NSArray *)kits {
    
    NSAssert([Fabric class], @"Fabric is not included");
    NSAssert([[Fabric class] respondsToSelector:@selector(sharedSDK)], @"Fabric library not installed correctly.");
    
    NSAssert(kits.count, @"Neither of Fabric kits was specified, can't init Fabric");
    
    [Fabric with:kits];
    
    if (![kits containsObject:[Crashlytics class]]){
        return nil;// we don't need provider in case if we are not interested in Crashlytics but want to initialize Fabric
    }

    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    if (userID) {
        [[Crashlytics sharedInstance] setUserIdentifier:userID];
    }

    if (email) {
        [[Crashlytics sharedInstance] setUserEmail:email];
    }
}

- (void)setUserProperty:(NSString *)property toValue:(id)value {
    [[Crashlytics sharedInstance] setObjectValue:value forKey:property];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    if (event.length > 0) {
        properties = properties ?: @{};
        [Answers logCustomEventWithName:event customAttributes:properties];
    }
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    [self didShowNewPageView:pageTitle withProperties:nil];
}

- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties {
    if (pageTitle.length > 0) {
        properties = properties ?: @{};
        [Answers logContentViewWithName:pageTitle contentType:nil contentId:nil customAttributes:properties];
    }
}

- (void)remoteLog:(NSString *)parsedString {
    CLSLog(@"%@", parsedString);
}


- (void)error:(NSError *)error withMessage:(NSString *)message {
    [[Crashlytics sharedInstance] recordError:error withAdditionalUserInfo:@{@"message": message}];
}

#endif
@end
