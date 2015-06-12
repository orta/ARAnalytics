#import "KeenProvider.h"
#import "KeenClient.h"

@implementation KeenProvider

- (instancetype)initWithProjectID:(NSString *)projectID andWriteKey:(NSString *)writeKey andReadKey:(NSString *)readKey {
#ifdef AR_KEEN_EXISTS
    NSAssert([KeenClient class], @"Keen Client is not included");
    [KeenClient sharedClientWithProjectId:projectID andWriteKey:writeKey andReadKey:readKey];
#endif
    return [super init];
}

#ifdef AR_KEEN_EXISTS

// Additional implementations go here.

#endif
@end
