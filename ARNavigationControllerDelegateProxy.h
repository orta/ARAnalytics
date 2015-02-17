@protocol UINavigationControllerDelegate;
/**
 * @note Delegates are typically not retained, but in this case we will take responsibility for them as we're essentially a man in the middle and we don't want to lose them.
 */
@interface ARNavigationControllerDelegateProxy : NSProxy<UINavigationControllerDelegate>

@property (nonatomic, strong) NSObject<UINavigationControllerDelegate> *originalDelegate;

- (instancetype)initWithAnalyticsDelegate:(NSObject<UINavigationControllerDelegate> *)analyticsDelegate;

@end
