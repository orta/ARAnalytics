#import "KeenProvider.h"
#import "KeenClient.h"

@implementation KeenProvider

- (instancetype)initWithProjectId:(NSString *)projectId andWriteKey:(NSString *)writeKey andReadKey:(NSString *)readKey {
#ifdef AR_KEEN_EXISTS
    NSAssert([KeenClient class], @"Keen Client is not included");
    [KeenClient sharedClientWithProjectId:projectId andWriteKey:writeKey andReadKey:readKey];
#endif
    return [super init];
}

#ifdef AR_KEEN_EXISTS

// Additional implementations go here.

#endif
@end
