// For OS X support we need to mock up UIVIewController/UINavigationViewController

#if !TARGET_OS_IPHONE
@interface UIViewController : NSObject @end
@interface UINavigationController : NSObject @end
@protocol UINavigationControllerDelegate <NSObject> @end
#endif

@class TSConfig;
@class ARAnalyticalProvider;

@protocol AdjustDelegate;

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
+ (void)setupFabricWithKits:(NSArray *)kits;
+ (void)setupMixpanelWithToken:(NSString *)token;
+ (void)setupMixpanelWithToken:(NSString *)token andHost:(NSString *)host;
+ (void)setupFlurryWithAPIKey:(NSString *)key;
+ (void)setupGoogleAnalyticsWithID:(NSString *)identifier;
+ (void)setupFirebaseAnalytics;
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
+ (void)setupSegmentioWithWriteKey:(NSString*)key integrations:(NSArray *)integrations;
+ (void)setupSwrveWithAppID:(NSString *)appID apiKey:(NSString *)apiKey;
+ (void)setupYandexMobileMetricaWithAPIKey:(NSString*)key;
+ (void)setupAdjustWithAppToken:(NSString *)token andConfigurationDelegate:(id<AdjustDelegate>)delegate;
+ (void)setupBranchWithAPIKey:(NSString *)key;
+ (void)setupSnowplowWithAddress:(NSString *)address;
+ (void)setupSentryWithID:(NSString *)identifier;
+ (void)setupIntercomWithAppID:(NSString *)identifier apiKey:(NSString *)apiKey;
+ (void)setupKeenWithProjectID:(NSString *)projectId andWriteKey:(NSString *)writeKey andReadKey:(NSString *)readKey;

+ (void)setupAdobeWithData:(NSDictionary *)additionalData otherSettings:(NSDictionary *)settings;
+ (void)setupInstallTrackerWithApplicationID:(NSString *)applicationID;
+ (void)setupAppseeWithAPIKey:(NSString *)key;
+ (void)setupMobileAppTrackerWithAdvertiserID:(NSString *)advertiserID conversionKey:(NSString *)conversionKey allowedEvents:(NSArray *)allowedEvents;
+ (void)setupLaunchKitWithAPIToken:(NSString *)token;
+ (void)setupLeanplumWithAppId:(NSString *)appId developmentKey:(NSString *)developmentKey productionKey:(NSString *)productionKey;
+ (void)setupAppboy;

/// Add a provider manually
+ (void)setupProvider:(ARAnalyticalProvider *)provider;

/// Remove a provider manually
+ (void)removeProvider:(ARAnalyticalProvider *)provider;

/// Show all current providers
+ (NSSet *)currentProviders;

/// Get the instance of provider class which is setup ready.
/// Developer must setup this provider ready via above methods and the argument must be a subclass of
/// ARAnalyticalProvider or this method returns nil.
+ (ARAnalyticalProvider *)providerInstanceOfClass:(Class)ProviderClass;

/// Register a user and an associated email address, it is fine to send nils for either.
+ (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email;

/// Register a user and an associated email address, in addition allows you to pass in an ID that you previously used
/// to track events when the user did not authenticate yet. E.g. `-[UIDevice identifierForVendor]`.
///
/// Currently only the Segment provider makes use of this and only when using version TODO or up of their SDK.
+ (void)identifyUserWithID:(NSString *)userID anonymousID:(NSString *)anonymousID andEmailAddress:(NSString *)email;

/// Set a per user property
+ (void)setUserProperty:(NSString *)property toValue:(id)value;

/// Adds to a user property if support exists in the provider
+ (void)incrementUserProperty:(NSString *)counterName byInt:(NSInteger)amount;

/// Submit user events to providers
+ (void)event:(NSString *)event;

/// Submit user events to providers with additional properties
+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties;

/// Adds super properties, these are properties that are sent along with
/// in addition to the event properties.
+ (void)addEventSuperProperties:(NSDictionary *)superProperties;

/// Removes a super property from the super properties.
+ (void)removeEventSuperProperty:(NSString *)key;

/// Removes super properties from the super properties.
+ (void)removeEventSuperProperties:(NSArray *)keys;

/// Submit errors to providers
+ (void)error:(NSError *)error;

/// Submit errors to providers with an associated message
+ (void)error:(NSError *)error withMessage:(NSString *)message;

/// Monitor Navigation changes as page view
+ (void)pageView:(NSString *)pageTitle;

/// Monitor Navigation changes as page view with additional properties
+ (void)pageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties;

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
extern void ARLogv (NSString *format, va_list argList) NS_FORMAT_FUNCTION(1,0);

/// A try-catch for nil protection wrapped event
extern void ARAnalyticsEvent (NSString *event, NSDictionary *properties);

/// Provide keys for the setupWithDictionary
extern NSString * const ARCountlyAppKey;
extern NSString * const ARCountlyHost;
extern NSString * const ARTestFlightAppToken;
extern NSString * const ARCrashlyticsAPIKey;
extern NSString * const ARFabricKits;
extern NSString * const ARMixpanelToken;
extern NSString * const ARMixpanelHost;
extern NSString * const ARFlurryAPIKey;
extern NSString * const ARLocalyticsAppKey;
extern NSString * const ARKISSMetricsAPIKey;
extern NSString * const ARBugsnagAPIKey;
extern NSString * const ARCrittercismAppID;
extern NSString * const ARGoogleAnalyticsID;
extern NSString * const ARHelpshiftAppID;
extern NSString * const ARHelpshiftDomainName;
extern NSString * const ARHelpshiftAPIKey;
extern NSString * const ARTapstreamAccountName;
extern NSString * const ARTapstreamDeveloperSecret;
extern NSString * const ARTapstreamConfig;
extern NSString * const ARNewRelicAppToken;
extern NSString * const ARAmplitudeAPIKey;
extern NSString * const ARHockeyAppBetaID;
extern NSString * const ARHockeyAppLiveID;
extern NSString * const ARParseApplicationID;
extern NSString * const ARParseClientKey;
extern NSString * const ARHeapAppID;
extern NSString * const ARChartbeatID;
extern NSString * const ARUMengAnalyticsID;
extern NSString * const ARLibratoEmail;
extern NSString * const ARLibratoToken;
extern NSString * const ARLibratoPrefix;
extern NSString * const ARSegmentioWriteKey;
extern NSString * const ARSegmentioIntegrationsKey;
extern NSString * const ARSwrveAppID;
extern NSString * const ARSwrveAPIKey;
extern NSString * const ARYandexMobileMetricaAPIKey;
extern NSString * const ARAdjustAppTokenKey;
extern NSString * const ARAppsFlyerAppID;
extern NSString * const ARAppsFlyerDevKey;
extern NSString * const ARBranchAPIKey;
extern NSString * const ARSnowplowURL;
extern NSString * const ARSentryID;
extern NSString * const ARIntercomAppID;
extern NSString * const ARIntercomAPIKey;
extern NSString * const ARKeenProjectID;
extern NSString * const ARKeenWriteKey;
extern NSString * const ARKeenReadKey;
extern NSString * const ARAdobeData;
extern NSString * const ARAdobeSettings;
extern NSString * const ARInstallTrackerApplicationID;
extern NSString * const ARAppseeAPIKey;
extern NSString * const ARMobileAppTrackerAdvertiserID;
extern NSString * const ARMobileAppTrackerConversionKey;
extern NSString * const ARMobileAppTrackerAllowedEvents;
extern NSString * const ARLaunchKitAPIToken;
