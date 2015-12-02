#import "FabricProvider.h"

@interface Crashlytics : NSObject
+ (Crashlytics *)sharedInstance;
- (void)setUserIdentifier:(NSString *)identifier;
- (void)setUserName:(NSString *)name;
- (void)setUserEmail:(NSString *)email;
- (void)setObjectValue:(id)value forKey:(NSString *)key;
@end

@implementation FabricProvider
#ifdef AR_FABRIC_EXISTS

- (id)initWithKits:(NSArray *)kits {
    
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
    NSString *log;
    if (properties) {
        log = [NSString stringWithFormat:@"%@%@", event, properties];
    } else {
        log = event;
    }
    
    CLSLog(@"%@", log);
}

- (void)remoteLog:(NSString *)parsedString {
    CLSLog(@"%@", parsedString);
}

#endif
@end
