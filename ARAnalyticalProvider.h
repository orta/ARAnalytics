@class UINavigationController, UIViewController;

extern NSString *const ARAnalyticalProviderNewPageViewEventName;
extern NSString *const ARAnalyticalProviderNewPageViewEventScreenPropertyKey;

@interface ARAnalyticalProvider : NSObject

/// Init
- (instancetype)initWithIdentifier:(NSString *)identifier;

/// Set a per user property
- (void)setUserProperty:(NSString *)property toValue:(id)value;
- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email;

/// For backwards compatibility, this method by default invokes `-identifyUserWithID:andEmailAddress:` and assigns the
/// `anonymousID` as a user property, if given, with the key `anonymous_id`.
///
/// @note If you override this method, be sure to also override that method and have it invoke this one instead.
- (void)identifyUserWithID:(NSString *)userID anonymousID:(NSString *)anonymousID andEmailAddress:(NSString *)email;

/// Submit user events
- (void)event:(NSString *)event withProperties:(NSDictionary *)properties;
- (void)incrementUserProperty:(NSString *)counterName byInt:(NSNumber *)amount;

/// Submit errors
- (void)error:(NSError *)error withMessage:(NSString *)message;

/// Monitor Navigation changes as page view
- (void)monitorNavigationViewController:(UINavigationController *)controller;

/// Submit an event with a time interval
- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval;

/// Submit an event with a time interval and extra properties
/// @warning the properites must not contain the key string `length`.
- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval properties:(NSDictionary *)properties;

/// Pass a specific event for showing a page
- (void)didShowNewPageView:(NSString *)pageTitle;

/// Pass a specific event for showing a page with additional properties
- (void)didShowNewPageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties;

/// Submit a string to the provider's logging system
- (void)remoteLog:(NSString *)parsedString;

/// Submit a string to the local persisted logging system
- (void)localLog:(NSString *)message;

/// Retrieve messages provided to the local persisted logging system originating from a specified process.
- (NSArray *)messagesForProcessID:(NSUInteger)processID;

@end
