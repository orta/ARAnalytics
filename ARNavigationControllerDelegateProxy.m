#import <UIKit/UIKit.h>
#import "ARNavigationControllerDelegateProxy.h"

@interface ARNavigationControllerDelegateProxy ()

@property (nonatomic, strong, readonly) NSObject<UINavigationControllerDelegate> *analyticsDelegate;

@end

@implementation ARNavigationControllerDelegateProxy

- (instancetype)initWithAnalyticsDelegate:(NSObject<UINavigationControllerDelegate> *)analyticsDelegate {
    // No need for [super init], it does not exist
    _analyticsDelegate = analyticsDelegate;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    SEL selector = [invocation selector];
    
    BOOL canRespond = NO;
    
    // Let the analytics delegate have a chance to intercept the messages
    if ([self analyticsDelegateRespondsToSelector:selector]) {
        [invocation invokeWithTarget:self.analyticsDelegate];
        canRespond = YES;
    }
    
    // Invoke original delegate last so return value is set correctly
    if ([self.originalDelegate respondsToSelector:selector]) {
        [invocation invokeWithTarget:self.originalDelegate];
        canRespond = YES;
    }
    
    if (!canRespond) {
        // Don't check if it responds to the selector so we get the 'doesNotRecongizeSelector:' exception on the original delegate
        [invocation invokeWithTarget:self.originalDelegate];
    }
}

- (BOOL)analyticsDelegateRespondsToSelector:(SEL)selector {
    
    return [self.analyticsDelegate respondsToSelector:selector] && ![[NSObject class] instancesRespondToSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    return [self.originalDelegate respondsToSelector:aSelector] || [self analyticsDelegateRespondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {

    // Try original delegate first
    NSMethodSignature *signature = [self.originalDelegate methodSignatureForSelector:selector];
    if (signature) {
        return signature;
    }
    
    // Fall back to analytics delegate
    return [self.analyticsDelegate methodSignatureForSelector:selector];
}

@end

