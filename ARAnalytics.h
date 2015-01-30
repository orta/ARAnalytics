// For OS X support we need to mock up UIVIewController/UINavigationViewController

#if !TARGET_OS_IPHONE
@interface UIViewController : NSObject @end
@interface UINavigationController : NSObject @end
@protocol UINavigationControllerDelegate <NSObject> @end
#endif

@class TSConfig;
@class ARAnalyticalProvider;

/**
 @class
 ARAnalytics Main Class.

 @abstract
 The primary interface for dealing with in app Analytics.

 @discussion
 Use the ARAnalytics class to set up your analytics provider and track events.

 <pre>

 [ARAnalytics setupWithAnalytics: @{
 ARCrittercismAppID : @"KEY",
 ARKISSMetricsAPIKey : @"KEY",
 ARGoogleAnalyticsID : @"KEY"
 }];

 </pre>

 For more advanced usage, please see the <a
 href="https://github.com/orta/ARAnalytics">ARAnalytics Readme</a>.
 */

@interface ARAnalytics : NSObject <UINavigationControllerDelegate>

/**
 *  A flag that setup ARAnalytics to print it's log (ARLog) to stdout or not.
 *
 *  By default, ARLog collects log messages to providers and print them on the stdout.
 *  If you want make the stdout clean while developing, you could set this flag to NO.
 *
 *  @param shouldPrint If YES, the ARLog will also print log message to stdout
 */
+ (void)logShouldPrintStdout:(BOOL)shouldPrint;

/// A global setup analytics API, keys are provided at the bottom of the documentation.
+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary;

/// Setup methods for each individual analytics providers
+ (void)setupTestFlightWithAppToken:(NSString *)token;
+ (void)setupCrashlyticsWithAPIKey:(NSString *)key;
+ (void)setupMixpanelWithToken:(NSString *)token;
+ (void)setupMixpanelWithToken:(NSString *)token andHost:(NSString *)host;
+ (void)setupFlurryWithAPIKey:(NSString *)key;
+ (void)setupGoogleAnalyticsWithID:(NSString *)identifier;
+ (void)setupLocalyticsWithAppKey:(NSString *)key;
+ (void)setupKISSMetricsWithAPIKey:(NSString *)key;
+ (void)setupCrittercismWithAppID:(NSString *)appID;
+ (void)setupCountlyWithAppKey:(NSString *)key andHost:(NSString *)host;
+ (void)setupBugsnagWithAPIKey:(NSString *)key;
+ (void)setupHelpshiftWithAppID:(NSString *)appID domainName:(NSString *)domainName apiKey:(NSString *)apiKey;
+ (void)setupTapstreamWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret;
+ (void)setupTapstreamWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret config:(TSConfig *)config;
+ (void)setupNewRelicWithAppToken:(NSString *)token;
+ (void)setupAmplitudeWithAPIKey:(NSString *)key;
+ (void)setupHockeyAppWithBetaID:(NSString *)betaID;
+ (void)setupHockeyAppWithBetaID:(NSString *)beta liveID:(NSString *)liveID;
+ (void)setupParseAnalyticsWithApplicationID:(NSString *)appID clientKey:(NSString *)clientKey;
+ (void)setupHeapAnalyticsWithApplicationID:(NSString *)appID;
+ (void)setupChartbeatWithApplicationID:(NSString *)appID;
+ (void)setupLibratoWithEmail:(NSString *)email token:(NSString *)token prefix:(NSString *)prefix;
+ (void)setupSegmentioWithWriteKey:(NSString*)key;
+ (void)setupSwrveWithAppID:(NSString *)appID apiKey:(NSString *)apiKey;
+ (void)setupYandexMobileMetricaWithAPIKey:(NSString*)key;
+ (void)setupAdjustWithAppToken:(NSString *)token;
+ (void)setupBranchWithAPIKey:(NSString *)key;

/// Add a provider manually
+ (void)setupProvider:(ARAnalyticalProvider *)provider;

/// Remove a provider manually
+ (void)removeProvider:(ARAnalyticalProvider *)provider;

/// Show all current providers
+ (NSSet *)currentProviders;

/// Get the instance of provider class which is setup ready.
/// Developer must setup this provider ready via above methods and the argument must be a subclass of
/// ARAnalyticalProvider or this methid returns nil.
+ (ARAnalyticalProvider *)providerInstanceOfClass:(Class)ProviderClass;

/// Register a user and an associated email address, it is fine to send nils for either.
+ (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email;

/// Set a per user property
+ (void)setUserProperty:(NSString *)property toValue:(NSString *)value;

/// Adds to a user property if support exists in the provider
+ (void)incrementUserProperty:(NSString *)counterName byInt:(NSInteger)amount;

/// Submit user events to providers
+ (void)event:(NSString *)event;

/// Submit user events to providers with additional properties
+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties;

/// Adds super properties, these are properties that are sent along with
/// in addition to the event properties.
+ (void)addEventSuperProperties:(NSDictionary *)superProperties;

/// Submit errors to providers
+ (void)error:(NSError *)error;

/// Submit errors to providers with an associated message
+ (void)error:(NSError *)error withMessage:(NSString *)message;

/// Monitor Navigation changes as page view
+ (void)pageView:(NSString *)pageTitle;

#if TARGET_OS_IPHONE
/// Monitor a navigation controller, submitting each [ARAnalytics pageView:] on didShowViewController
/// @warning Deprecated in favour of monitorNavigationController:
+ (void)monitorNavigationViewController:(UINavigationController *)controller __attribute__((deprecated));

/// Monitor a navigation controller, submitting each [ARAnalytics pageView:] on didShowViewController
+ (void)monitorNavigationController:(UINavigationController *)controller;
#endif

/// Let ARAnalytics deal with the timing of an event
+ (void)startTimingEvent:(NSString *)event;

/// Trigger a finishing event for the timing
+ (void)finishTimingEvent:(NSString *)event;

/// @warning the properites must not contain the key string `length` .
+ (void)finishTimingEvent:(NSString *)event withProperties:(NSDictionary *)properties;

@end

/// an NSLog-like command that send to providers
extern void ARLog (NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

/// A try-catch for nil protection wrapped event
extern void ARAnalyticsEvent (NSString *event, NSDictionary *properties);

/// Provide keys for the setupWithDictionary
extern const NSString *ARCountlyAppKey;
extern const NSString *ARCountlyHost;
extern const NSString *ARTestFlightAppToken;
extern const NSString *ARCrashlyticsAPIKey;
extern const NSString *ARMixpanelToken;
extern const NSString *ARMixpanelHost;
extern const NSString *ARFlurryAPIKey;
extern const NSString *ARLocalyticsAppKey;
extern const NSString *ARKISSMetricsAPIKey;
extern const NSString *ARBugsnagAPIKey;
extern const NSString *ARCrittercismAppID;
extern const NSString *ARGoogleAnalyticsID;
extern const NSString *ARHelpshiftAppID;
extern const NSString *ARHelpshiftDomainName;
extern const NSString *ARHelpshiftAPIKey;
extern const NSString *ARTapstreamAccountName;
extern const NSString *ARTapstreamDeveloperSecret;
extern const NSString *ARTapstreamConfig;
extern const NSString *ARNewRelicAppToken;
extern const NSString *ARAmplitudeAPIKey;
extern const NSString *ARHockeyAppBetaID;
extern const NSString *ARHockeyAppLiveID;
extern const NSString *ARParseApplicationID;
extern const NSString *ARParseClientKey;
extern const NSString *ARHeapAppID;
extern const NSString *ARChartbeatID;
extern const NSString *ARUMengAnalyticsID;
extern const NSString *ARLibratoEmail;
extern const NSString *ARLibratoToken;
extern const NSString *ARLibratoPrefix;
extern const NSString *ARSegmentioWriteKey;
extern const NSString *ARSwrveAppID;
extern const NSString *ARSwrveAPIKey;
extern const NSString *ARYandexMobileMetricaAPIKey;
extern const NSString *ARAdjustAppTokenKey;
extern const NSString *ARAppsFlyerAppID;
extern const NSString *ARAppsFlyerDevKey;
extern const NSString *ARBranchAPIKey;

