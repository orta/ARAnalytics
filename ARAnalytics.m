#import "ARAnalytics.h"
#import "ARAnalyticalProvider.h"
#import "ARAnalyticsProviders.h"

static ARAnalytics *_sharedAnalytics;
static BOOL _ARLogShouldPrintStdout = YES;

@interface ARAnalytics ()
@property (readwrite, nonatomic, strong) NSMutableDictionary *superProperties;
@property (readwrite, nonatomic, strong) NSMutableDictionary *eventsDictionary;
@property (readwrite, nonatomic, copy) NSSet *providers;
@end

#if TARGET_OS_IPHONE
#import "ARNavigationControllerDelegateProxy.h"
@interface ARAnalytics ()
{
    ARNavigationControllerDelegateProxy *_proxyDelegate;
}
@property (strong, readonly) ARNavigationControllerDelegateProxy *proxyDelegate;
@end
#endif

#if !TARGET_OS_IPHONE
@implementation UIViewController @end
@implementation UINavigationController @end
#endif

@implementation ARAnalytics

+ (void)initialize
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _sharedAnalytics = [[ARAnalytics alloc] init];
        _sharedAnalytics.providers = [NSSet set];
        _sharedAnalytics.superProperties = [NSMutableDictionary dictionary];
    });
}

+ (void)logShouldPrintStdout:(BOOL)shouldPrint
{
    _ARLogShouldPrintStdout = shouldPrint;
}

#pragma mark -
#pragma mark Analytics Setup

// By using the constants at the bottom you can 

+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary
{
    if (analyticsDictionary[ARTestFlightAppToken]) {
        [self setupTestFlightWithAppToken:analyticsDictionary[ARTestFlightAppToken]];
    }

    if (analyticsDictionary[ARFlurryAPIKey]) {
        [self setupFlurryWithAPIKey:analyticsDictionary[ARFlurryAPIKey]];
    }

    if (analyticsDictionary[ARGoogleAnalyticsID]) {
        [self setupGoogleAnalyticsWithID:analyticsDictionary[ARGoogleAnalyticsID]];
    }

    if (analyticsDictionary[ARKISSMetricsAPIKey]) {
        [self setupKISSMetricsWithAPIKey:analyticsDictionary[ARKISSMetricsAPIKey]];
    }

    if (analyticsDictionary[ARLocalyticsAppKey]) {
        [self setupLocalyticsWithAppKey:analyticsDictionary[ARLocalyticsAppKey]];
    }

    if (analyticsDictionary[ARMixpanelToken]) {
        // ARMixpanelHost is nil if you want the default provider. So we can make
        // the presumption of it here.
        [self setupMixpanelWithToken:analyticsDictionary[ARMixpanelToken] andHost:analyticsDictionary[ARMixpanelHost]];
    }

    if (analyticsDictionary[ARCountlyAppKey]) {
        // ARCountlyHost is nil if you want the cloud host.
        // If the host URL is not nil the it should be provided without the slash at the end.
        [self setupCountlyWithAppKey:analyticsDictionary[ARCountlyAppKey] andHost:analyticsDictionary[ARCountlyHost]];
    }

    if (analyticsDictionary[ARBugsnagAPIKey]) {
        [self setupBugsnagWithAPIKey:analyticsDictionary[ARBugsnagAPIKey]];
    }
    
    if (analyticsDictionary[ARHelpshiftAppID] && analyticsDictionary[ARHelpshiftDomainName] && analyticsDictionary[ARHelpshiftAPIKey]) {
        [self setupHelpshiftWithAppID:analyticsDictionary[ARHelpshiftAppID] domainName:analyticsDictionary[ARHelpshiftDomainName] apiKey:analyticsDictionary[ARHelpshiftAPIKey]];
    }
    
    if (analyticsDictionary[ARTapstreamAccountName] && analyticsDictionary[ARTapstreamDeveloperSecret]) {
        [self setupTapstreamWithAccountName:analyticsDictionary[ARTapstreamAccountName] developerSecret:analyticsDictionary[ARTapstreamDeveloperSecret] config:analyticsDictionary[ARTapstreamConfig]];
    }
    
    if (analyticsDictionary[ARNewRelicAppToken]) {
        [self setupNewRelicWithAppToken:analyticsDictionary[ARNewRelicAppToken]];
    }
    
    if (analyticsDictionary[ARAmplitudeAPIKey]) {
        [self setupAmplitudeWithAPIKey:analyticsDictionary[ARAmplitudeAPIKey]];
    }

    if (analyticsDictionary[ARHockeyAppBetaID]) {
        [self setupHockeyAppWithBetaID:analyticsDictionary[ARHockeyAppBetaID] liveID:analyticsDictionary[ARHockeyAppLiveID]];
    }
    
    if (analyticsDictionary[ARParseApplicationID] && analyticsDictionary[ARParseClientKey]) {
        [self setupParseAnalyticsWithApplicationID:analyticsDictionary[ARParseApplicationID] clientKey:analyticsDictionary[ARParseClientKey]];
    }

    if (analyticsDictionary[ARHeapAppID]) {
        [self setupHeapAnalyticsWithApplicationID:analyticsDictionary[ARHeapAppID]];
    }
    
    if (analyticsDictionary[ARChartbeatID]) {
        [self setupChartbeatWithApplicationID:analyticsDictionary[ARChartbeatID]];
    }
    
    if (analyticsDictionary[ARUMengAnalyticsID]) {
        [self setupUMengAnalyticsIDWithAppkey:analyticsDictionary[ARUMengAnalyticsID]];
    }
    
    if (analyticsDictionary[ARLibratoEmail] && analyticsDictionary[ARLibratoToken]) {
        [self setupLibratoWithEmail:analyticsDictionary[ARLibratoEmail] token:analyticsDictionary[ARLibratoToken] prefix:analyticsDictionary[ARLibratoPrefix]];
    }

    if (analyticsDictionary[ARSegmentioWriteKey]) {
        [self setupSegmentioWithWriteKey:analyticsDictionary[ARSegmentioWriteKey] integrations:analyticsDictionary[ARSegmentioIntegrationsKey]];
    }

    if (analyticsDictionary[ARSwrveAppID] && analyticsDictionary[ARSwrveAPIKey]) {
        [self setupSwrveWithAppID:analyticsDictionary[ARSwrveAppID] apiKey:analyticsDictionary[ARSwrveAPIKey]];
    }

    if (analyticsDictionary[ARAppsFlyerAppID] && analyticsDictionary[ARAppsFlyerDevKey]) {
        [self setupAppsFlyerWithAppID:analyticsDictionary[ARAppsFlyerAppID] devKey:analyticsDictionary[ARAppsFlyerDevKey]];
    }

    if (analyticsDictionary[ARYandexMobileMetricaAPIKey]) {
        [self setupYandexMobileMetricaWithAPIKey:analyticsDictionary[ARYandexMobileMetricaAPIKey]];
    }
    
    if (analyticsDictionary[ARAdjustAppTokenKey]) {
        [self setupAdjustWithAppToken:analyticsDictionary[ARAdjustAppTokenKey] andConfigurationDelegate:nil];
    }

    if (analyticsDictionary[ARSnowplowURL]) {
        [self setupSnowplowWithAddress:analyticsDictionary[ARSnowplowURL]];
    }
    
    if (analyticsDictionary[ARSentryID]) {
        [self setupSentryWithID:analyticsDictionary[ARSentryID]];
    }

    if (analyticsDictionary[ARIntercomAppID] && analyticsDictionary[ARIntercomAPIKey]) {
        [self setupIntercomWithAppID:analyticsDictionary[ARIntercomAppID] apiKey:analyticsDictionary[ARIntercomAPIKey]];
    }

    if (analyticsDictionary[ARKeenProjectID] && analyticsDictionary[ARKeenWriteKey] && analyticsDictionary[ARKeenReadKey]) {
        [self setupKeenWithProjectID:analyticsDictionary[ARKeenProjectID] andWriteKey:analyticsDictionary[ARKeenWriteKey] andReadKey:analyticsDictionary[ARKeenReadKey]];
    }

    if (analyticsDictionary[ARAdobeData]) {
        [self setupAdobeWithData:analyticsDictionary[ARAdobeData] otherSettings:analyticsDictionary[ARAdobeSettings]];
    }
    
    if (analyticsDictionary[ARInstallTrackerApplicationID]) {
        [self setupInstallTrackerWithApplicationID:analyticsDictionary[ARInstallTrackerApplicationID]];
    }

    if (analyticsDictionary[ARAppseeAPIKey]) {
        [self setupAppseeWithAPIKey:analyticsDictionary[ARAppseeAPIKey]];
    }
    
    if (analyticsDictionary[ARMobileAppTrackerAdvertiserID] &&
        analyticsDictionary[ARMobileAppTrackerConversionKey] &&
        analyticsDictionary[ARMobileAppTrackerAllowedEvents]) {
        
        [self setupMobileAppTrackerWithAdvertiserID:analyticsDictionary[ARMobileAppTrackerAdvertiserID]
                                      conversionKey:analyticsDictionary[ARMobileAppTrackerConversionKey]
                                      allowedEvents:analyticsDictionary[ARMobileAppTrackerAllowedEvents]];
    }
    
    if (analyticsDictionary[ARLaunchKitAPIToken]) {
        [self setupLaunchKitWithAPIToken:analyticsDictionary[ARLaunchKitAPIToken]];
    }
    
    // Add future integrations here:



    // Crashlytics / Crittercism should stay at the bottom of this method,
    // as they both need to register exceptions, and you'd only use one.

    if (analyticsDictionary[ARCrashlyticsAPIKey]) {
        [self setupCrashlyticsWithAPIKey:analyticsDictionary[ARCrashlyticsAPIKey]];
    }
    if (analyticsDictionary[ARFabricKits]) {
        [self setupFabricWithKits:analyticsDictionary[ARFabricKits]];
    }

    if (analyticsDictionary[ARCrittercismAppID]) {
        [self setupCrittercismWithAppID:analyticsDictionary[ARCrittercismAppID]];
    }
}

+ (void)setupProvider:(ARAnalyticalProvider*)provider
{
    _sharedAnalytics.providers = [_sharedAnalytics.providers setByAddingObject:provider];
}

+ (void)removeProvider:(ARAnalyticalProvider *)provider
{
    NSMutableSet *mutableSet = [NSMutableSet setWithSet:_sharedAnalytics.providers];
    [mutableSet removeObject:provider];
    _sharedAnalytics.providers = mutableSet;
}

+ (NSSet *)currentProviders
{
    return _sharedAnalytics.providers;
}

+ (ARAnalyticalProvider *)providerInstanceOfClass:(Class)ProviderClass
{
    // Check whether the ProviderClass is subclass of ARAnalyticalProvider or not
    if (![ProviderClass isSubclassOfClass:ARAnalyticalProvider.class]) {
        return nil;
    }

    // Find the instance by enumerating the providers set
    ARAnalyticalProvider *__block providerInstance = nil;
    [_sharedAnalytics.providers enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        // Get the proivder and return it
        if ((*stop = [obj isKindOfClass:ProviderClass])) {
            providerInstance = obj;
        }
    }];
    return providerInstance;
}

+ (void)setupTestFlightWithAppToken:(NSString *)token
{
#ifdef AR_TESTFLIGHT_EXISTS
    TestFlightProvider *provider = [[TestFlightProvider alloc] initWithIdentifier:token];
    [self setupProvider:provider];
#endif
}

+ (void)setupCrashlyticsWithAPIKey:(NSString *)key
{
#ifdef AR_CRASHLYTICS_EXISTS
    CrashlyticsProvider *provider = [[CrashlyticsProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupFabricWithKits:(NSArray *)kits
{
#ifdef AR_FABRIC_EXISTS
    FabricProvider *provider = [[FabricProvider alloc] initWithKits:kits];
    if (provider){
        [self setupProvider:provider];
    }
#endif
}

+ (void)setupMixpanelWithToken:(NSString *)token
{
#ifdef AR_MIXPANEL_EXISTS
    [self setupMixpanelWithToken:token andHost:nil];
#endif
}

+ (void)setupMixpanelWithToken:(NSString *)token andHost:(NSString *)host
{
#ifdef AR_MIXPANEL_EXISTS
    MixpanelProvider *provider = [[MixpanelProvider alloc] initWithIdentifier:token andHost:host];
    [self setupProvider:provider];
#endif
}

+ (void)setupFlurryWithAPIKey:(NSString *)key
{
#ifdef AR_FLURRY_EXISTS
    FlurryProvider *provider = [[FlurryProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupGoogleAnalyticsWithID:(NSString *)identifier
{
#ifdef AR_GOOGLEANALYTICS_EXISTS
    GoogleAnalyticsProvider *provider = [[GoogleAnalyticsProvider alloc] initWithIdentifier:identifier];
    [self setupProvider:provider];
#endif
}

+ (void)setupFirebaseAnalytics
{
#ifdef AR_FIREBASE_EXISTS
    FirebaseProvider *provider = [[FirebaseProvider alloc] initWithIdentifier:nil];
    [self setupProvider:provider];
#endif
}

+ (void)setupLocalyticsWithAppKey:(NSString *)key
{
#ifdef AR_LOCALYTICS_EXISTS
    LocalyticsProvider *provider = [[LocalyticsProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupKISSMetricsWithAPIKey:(NSString *)key
{
#ifdef AR_KISSMETRICS_EXISTS
    KISSMetricsProvider *provider = [[KISSMetricsProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupCrittercismWithAppID:(NSString *)appID
{
#ifdef AR_CRITTERCISM_EXISTS
    CrittercismProvider *provider = [[CrittercismProvider alloc] initWithIdentifier:appID];
    [self setupProvider:provider];
#endif
}

+ (void)setupCountlyWithAppKey:(NSString *)key andHost:(NSString *)host
{
#ifdef AR_COUNTLY_EXISTS
    CountlyProvider *provider = [[CountlyProvider alloc] initWithAppKey:key andHost:host];
    [self setupProvider:provider];
#endif
}

+ (void)setupBugsnagWithAPIKey:(NSString *)key
{
#ifdef AR_BUGSNAG_EXISTS
    BugsnagProvider *provider = [[BugsnagProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupHelpshiftWithAppID:(NSString *)appID domainName:(NSString *)domainName apiKey:(NSString *)apiKey
{
#ifdef AR_HELPSHIFT_EXISTS
    HelpshiftProvider *provider = [[HelpshiftProvider alloc] initWithAppID:appID domainName:domainName apiKey:apiKey];
    [self setupProvider:provider];
#endif
}

+ (void)setupTapstreamWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret
{
#ifdef AR_TAPSTREAM_EXISTS
    TapstreamProvider *provider = [[TapstreamProvider alloc] initWithAccountName:accountName developerSecret:developerSecret];
    [self setupProvider:provider];
#endif
}

+ (void)setupTapstreamWithAccountName:(NSString *)accountName developerSecret:(NSString *)developerSecret config:(TSConfig *)config
{
#ifdef AR_TAPSTREAM_EXISTS
    TapstreamProvider *provider = [[TapstreamProvider alloc] initWithAccountName:accountName developerSecret:developerSecret config:config];
    [self setupProvider:provider];
#endif
}

+ (void)setupNewRelicWithAppToken:(NSString *)token
{
#ifdef AR_NEWRELIC_EXISTS
    NewRelicProvider *provider = [[NewRelicProvider alloc] initWithIdentifier:token];
    [self setupProvider:provider];
#endif
}

+ (void)setupAmplitudeWithAPIKey:(NSString *)key
{
#ifdef AR_AMPLITUDE_EXISTS
     AmplitudeProvider *provider = [[AmplitudeProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupHockeyAppWithBetaID:(NSString *)betaID
{
#ifdef AR_HOCKEYAPP_EXISTS
    [self setupHockeyAppWithBetaID:betaID liveID:nil];
#endif
}

+ (void)setupHockeyAppWithBetaID:(NSString *)betaID liveID:(NSString *)liveID
{
#ifdef AR_HOCKEYAPP_EXISTS
    HockeyAppProvider *provider = [[HockeyAppProvider alloc] initWithBetaIdentifier:betaID liveIdentifier:liveID];
    [self setupProvider:provider];
#endif
}

+ (void)setupParseAnalyticsWithApplicationID:(NSString *)appID clientKey:(NSString *)clientKey
{
#ifdef AR_PARSEANALYTICS_EXISTS
    ParseAnalyticsProvider *provider = [[ParseAnalyticsProvider alloc] initWithApplicationID:appID clientKey:clientKey];
    [self setupProvider:provider];
#endif
}

+ (void)setupHeapAnalyticsWithApplicationID:(NSString *)appID
{
#ifdef AR_HEAPANALYTICS_EXISTS
    HeapAnalyticsProvider *provider = [[HeapAnalyticsProvider alloc] initWithIdentifier:appID];
    [self setupProvider:provider];
#endif
}

+ (void)setupChartbeatWithApplicationID:(NSString *)appID
{
#ifdef AR_CHARTBEAT_EXISTS
    ChartbeatProvider *provider = [[ChartbeatProvider alloc] initWithIdentifier:appID];
    [self setupProvider:provider];
#endif
}

+ (void)setupUMengAnalyticsIDWithAppkey:(NSString *)appID
{
#ifdef AR_UMENGANALYTICS_EXISTS
    UMengAnalyticsProvider *provider = [[UMengAnalyticsProvider alloc] initWithIdentifier:appID];
    [self setupProvider:provider];
#endif
}

+ (void)setupLibratoWithEmail:(NSString *)email token:(NSString *)token prefix:(NSString *)prefix
{
#ifdef AR_LIBRATO_EXISTS
    LibratoProvider *provider = [[LibratoProvider alloc] initWithEmail:email token:token prefix:prefix];
    [self setupProvider:provider];
#endif
}

+ (void)setupSegmentioWithWriteKey:(NSString *)key integrations:(NSArray *)integrations
{
#ifdef AR_SEGMENTIO_EXISTS
    SegmentioProvider *provider = [[SegmentioProvider alloc] initWithIdentifier:key integrations:integrations];
    [self setupProvider:provider];
#endif
}

+ (void)setupSwrveWithAppID:(NSString *)appID apiKey:(NSString *)apiKey
{
#ifdef AR_SWRVE_EXISTS
    SwrveProvider *provider = [[SwrveProvider alloc] initWithAppID:appID apiKey:apiKey];
    [self setupProvider:provider];
#endif
}

+ (void)setupYandexMobileMetricaWithAPIKey:(NSString *)key
{
#ifdef AR_YANDEXMOBILEMETRICA_EXISTS
    YandexMobileMetricaProvider *provider = [[YandexMobileMetricaProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupAdjustWithAppToken:(NSString *)token andConfigurationDelegate:(id<AdjustDelegate>)delegate
{
#ifdef AR_ADJUST_EXISTS
    AdjustProvider *provider = [[AdjustProvider alloc] initWithIdentifier:token andConfigurationDelegate:delegate];
    [self setupProvider:provider];
#endif
}

+ (void)setupAppsFlyerWithAppID:(NSString *)appID devKey:(NSString *)devKey 
{
#ifdef AR_APPSFLYER_EXISTS
    AppsFlyerProvider *provider = [[AppsFlyerProvider alloc] initWithAppID:appID devKey:devKey];
    [self setupProvider:provider];
#endif
}

+ (void)setupBranchWithAPIKey:(NSString *)key {
#ifdef AR_BRANCH_EXISTS
    BranchProvider *provider = [[BranchProvider alloc] initWithAPIKey:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupSnowplowWithAddress:(NSString *)address
{
#ifdef AR_SNOWPLOW_EXISTS
    SnowplowProvider *provider = [[SnowplowProvider alloc] initWithAddress:address];
    [self setupProvider:provider];
#endif
}

+ (void)setupSentryWithID:(NSString *)identifier
{
#ifdef AR_SENTRY_EXISTS
    SentryProvider *provider = [[SentryProvider alloc] initWithIdentifier:identifier];
    [self setupProvider:provider];
#endif
}

+ (void)setupIntercomWithAppID:(NSString *)identifier apiKey:(NSString *)apiKey
{
#ifdef AR_INTERCOM_EXISTS
    IntercomProvider *provider = [[IntercomProvider alloc] initWithWithAppID:identifier apiKey:apiKey];
    [self setupProvider:provider];
#endif
}

+ (void)setupKeenWithProjectID:(NSString *)projectId andWriteKey:(NSString *)writeKey andReadKey:(NSString *)readKey
{
#ifdef AR_KEEN_EXISTS
    KeenProvider *provider = [[KeenProvider alloc] initWithProjectID:projectId andWriteKey:writeKey andReadKey:readKey];
    [self setupProvider:provider];
#endif
}

+ (void)setupAdobeWithData:(NSDictionary *)additionalData otherSettings:(NSDictionary *)settings {
#ifdef AR_ADOBE_EXISTS
    AdobeProvider *provider = [[AdobeProvider alloc] initWithData:additionalData settings:settings];
    [self setupProvider:provider];
#endif
}

+ (void)setupInstallTrackerWithApplicationID:(NSString *)applicationID
{
#ifdef AR_INSTALLTRACKER_EXISTS
    InstallTrackerProvider *provider = [[InstallTrackerProvider alloc] initWithIdentifier:applicationID];
    [self setupProvider:provider];
#endif
}

+ (void)setupAppseeWithAPIKey:(NSString *)key
{
#ifdef AR_APPSEE_EXISTS
     AppseeProvider *provider = [[AppseeProvider alloc] initWithIdentifier:key];
    [self setupProvider:provider];
#endif
}

+ (void)setupMobileAppTrackerWithAdvertiserID:(NSString *)advertiserID conversionKey:(NSString *)conversionKey allowedEvents:(NSArray *)allowedEvents {
#ifdef AR_MOBILEAPPTRACKER_EXISTS
    MobileAppTrackerProvider *provider = [[MobileAppTrackerProvider alloc] initWithAdvertiserId:advertiserID
                                                                                  conversionKey:conversionKey
                                                                                  allowedEvents:allowedEvents];
    [self setupProvider:provider];
#endif
}

+ (void)setupLaunchKitWithAPIToken:(NSString *)token {
#ifdef AR_LAUNCHKIT_EXISTS
    LaunchKitProvider *provider = [[LaunchKitProvider alloc] initWithIdentifier:token];
    [self setupProvider:provider];
#endif
}

+ (void)setupLeanplumWithAppId:(NSString *)appId developmentKey:(NSString *)developmentKey productionKey:(NSString *)productionKey {
#ifdef AR_LEANPLUM_EXISTS
    LeanplumProvider *provider = [[LeanplumProvider alloc] initWithAppId:appId developmentKey:developmentKey productionKey:productionKey];
    [self setupProvider:provider];
#endif
}

+ (void)setupAppboy {
#ifdef AR_APPBOY_EXISTS
    AppboyProvider *provider = [[AppboyProvider alloc] initWithIdentifier:nil];
    [self setupProvider:provider];
#endif
}

#pragma mark -
#pragma mark User Setup

+ (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email
{
    [self identifyUserWithID:userID anonymousID:nil andEmailAddress:email];
}

+ (void)identifyUserWithID:(NSString *)userID anonymousID:(NSString *)anonymousID andEmailAddress:(NSString *)email
{
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider identifyUserWithID:userID anonymousID:anonymousID andEmailAddress:email];
    }];
}

+ (void)setUserProperty:(NSString *)property toValue:(id)value
{
    if (value == nil) {
        NSLog(@"ARAnalytics: Value cannot be nil ( %@ ) ", property);
        return;
    }

    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider setUserProperty:property toValue:value];
    }];
}

+ (void)incrementUserProperty:(NSString *)counterName byInt:(NSInteger)amount
{
    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider incrementUserProperty:counterName byInt:@(amount)];
    }];
}

#pragma mark -
#pragma mark Events


+ (void)event:(NSString *)event
{
    [self event:event withProperties:nil];
}

+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties
{
    NSMutableDictionary *fullProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
    [fullProperties addEntriesFromDictionary:_sharedAnalytics.superProperties];

    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider event:event withProperties:fullProperties];
    }];
}

+ (void)addEventSuperProperties:(NSDictionary *)superProperties
{
    [_sharedAnalytics.superProperties addEntriesFromDictionary:superProperties];
}

+ (void)removeEventSuperProperty:(NSString *)key;
{
    [_sharedAnalytics.superProperties removeObjectForKey:key];
}

+ (void)removeEventSuperProperties:(NSArray *)keys;
{
    [_sharedAnalytics.superProperties removeObjectsForKeys:keys];
}

#pragma mark -
#pragma mark Errors

+ (void)error:(NSError *)error
{
	[self error:error withMessage:nil];
}

+ (void)error:(NSError *)error withMessage:(NSString *)message
{
	[_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
		[provider error:error withMessage:message];
	}];
}

#pragma mark -
#pragma mark Screen views

+ (void)pageView:(NSString *)pageTitle
{
    [self pageView:pageTitle withProperties:nil];
}

+ (void)pageView:(NSString *)pageTitle withProperties:(NSDictionary *)properties
{
    if (!pageTitle) return;

    NSMutableDictionary *fullProperties = [properties ?: @{} mutableCopy];
    [fullProperties addEntriesFromDictionary:_sharedAnalytics.superProperties];

    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider didShowNewPageView:pageTitle withProperties:fullProperties];
    }];
}

#pragma mark -
#pragma mark Monitor Navigation Controller

+ (void)monitorNavigationViewController:(UINavigationController *)controller
{
    [self monitorNavigationController:controller];
}

+ (void)monitorNavigationController:(UINavigationController *)controller
{
#if TARGET_OS_IPHONE
    // Set a new original delegate on the proxy
    _sharedAnalytics.proxyDelegate.originalDelegate = controller.delegate;
    // Then set the new controllers delegate as the proxy
    controller.delegate = _sharedAnalytics.proxyDelegate;
#endif
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
#if TARGET_OS_IPHONE
    [self.class pageView:viewController.title];
#endif
}

#if TARGET_OS_IPHONE
/// Lazily loaded
- (ARNavigationControllerDelegateProxy *)proxyDelegate
{
    if (!_proxyDelegate) {
        _proxyDelegate = [[ARNavigationControllerDelegateProxy alloc] initWithAnalyticsDelegate:self];
    }
    return _proxyDelegate;
}
#endif

#pragma mark -
#pragma mark Timing Events

+ (void)startTimingEvent:(NSString *)event
{
    if (!_sharedAnalytics.eventsDictionary) {
        _sharedAnalytics.eventsDictionary = [NSMutableDictionary dictionary];
    }
    _sharedAnalytics.eventsDictionary[event] = [NSDate date];
}

+ (void)finishTimingEvent:(NSString *)event
{
    [self finishTimingEvent:event withProperties:nil];
}

+ (void)finishTimingEvent:(NSString *)event withProperties:(NSDictionary *)properties
{
    NSDate *startDate = _sharedAnalytics.eventsDictionary[event];
    if (!startDate) {
        NSLog(@"ARAnalytics: finish timing event (%@) called without a corrosponding start timing event", event);
        return;
    }

    NSTimeInterval eventInterval = [[NSDate date] timeIntervalSinceDate:startDate];
    [_sharedAnalytics.eventsDictionary removeObjectForKey:event];
    
    NSMutableDictionary *fullProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
    [fullProperties addEntriesFromDictionary:_sharedAnalytics.superProperties];

    [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
        [provider logTimingEvent:event withInterval:@(eventInterval) properties:fullProperties];
    }];
}

#pragma mark -
#pragma mark Util

- (void)iterateThroughProviders:(void(^)(ARAnalyticalProvider *provider))providerBlock
{
    for (ARAnalyticalProvider *provider in self.providers) {
        providerBlock(provider);
    }
}

@end

void ARLog (NSString *format, ...) {
    va_list argList;
    va_start(argList, format);
    ARLogv(format, argList);
    va_end(argList);
}

void ARLogv (NSString *format, va_list argList) {
    if (format == nil) {
        if (_ARLogShouldPrintStdout) {
            printf("nil \n");
        }
        return;
    }
    
    @autoreleasepool {
        NSString *parsedFormatString = [[NSString alloc] initWithFormat:format arguments:argList];
        parsedFormatString = [parsedFormatString stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"];
        if (_ARLogShouldPrintStdout) {
            printf("ARLog : %s\n", parsedFormatString.UTF8String);
        }

        [_sharedAnalytics iterateThroughProviders:^(ARAnalyticalProvider *provider) {
            [provider remoteLog:parsedFormatString];
        }];
    }
}

void ARAnalyticsEvent (NSString *event, NSDictionary *properties) {
  @try {
    [ARAnalytics event:event withProperties:properties];
  }

  @catch (NSException *exception) {
    NSLog(@"ARAnalytics: Exception raised when handling event %@ - %@ - %@", event, exception.name, exception.reason);
  }
}

NSString * const ARCountlyAppKey = @"ARCountlyAppKey";
NSString * const ARCountlyHost = @"ARCountlyHost";
NSString * const ARTestFlightAppToken = @"ARTestFlight";
NSString * const ARCrashlyticsAPIKey = @"ARCrashlytics";
NSString * const ARFabricKits = @"ARFabricKits";
NSString * const ARMixpanelToken = @"ARMixpanel";
NSString * const ARMixpanelHost = @"ARMixpanelHost";
NSString * const ARFlurryAPIKey = @"ARFlurry";
NSString * const ARBugsnagAPIKey = @"ARBugsnag";
NSString * const ARLocalyticsAppKey = @"ARLocalytics";
NSString * const ARKISSMetricsAPIKey = @"ARKISSMetrics";
NSString * const ARCrittercismAppID = @"ARCrittercism";
NSString * const ARGoogleAnalyticsID = @"ARGoogleAnalytics";
NSString * const ARHelpshiftAppID = @"ARHelpshiftAppID";
NSString * const ARHelpshiftDomainName = @"ARHelpshiftDomainName";
NSString * const ARHelpshiftAPIKey = @"ARHelpshiftAPIKey";
NSString * const ARTapstreamAccountName = @"ARTapstreamAccountName";
NSString * const ARTapstreamDeveloperSecret = @"ARTapstreamDeveloperSecret";
NSString * const ARTapstreamConfig = @"ARTapstreamConfig";
NSString * const ARNewRelicAppToken = @"ARNewRelicAppToken";
NSString * const ARAmplitudeAPIKey = @"ARAmplitudeAPIKey";
NSString * const ARHockeyAppLiveID = @"ARHockeyAppLiveID";
NSString * const ARHockeyAppBetaID = @"ARHockeyAppBetaID";
NSString * const ARParseApplicationID = @"ARParseApplicationID";
NSString * const ARParseClientKey = @"ARParseClientKey";
NSString * const ARHeapAppID = @"ARHeapAppID";
NSString * const ARChartbeatID = @"ARChartbeatID";
NSString * const ARUMengAnalyticsID = @"ARUMengAnalyticsID";
NSString * const ARLibratoEmail = @"ARLibratoEmail";
NSString * const ARLibratoToken = @"ARLibratoToken";
NSString * const ARLibratoPrefix = @"ARLibratoPrefix";
NSString * const ARSegmentioWriteKey = @"ARSegmentioWriteKey";
NSString * const ARSegmentioIntegrationsKey = @"ARSegmentioIntegrationsKey";
NSString * const ARSwrveAppID = @"ARSwrveAppID";
NSString * const ARSwrveAPIKey = @"ARSwrveAPIKey";
NSString * const ARYandexMobileMetricaAPIKey = @"ARYandexMobileMetricaAPIKey";
NSString * const ARAdjustAppTokenKey = @"ARAdjustAppTokenKey";
NSString * const ARAppsFlyerAppID = @"ARAppsFlyerAppID";
NSString * const ARAppsFlyerDevKey = @"ARAppsFlyerDevKey";
NSString * const ARBranchAPIKey = @"ARBranchAPIKey";
NSString * const ARSnowplowURL = @"ARSnowplowURL";
NSString * const ARSentryID = @"ARSentryID";
NSString * const ARIntercomAppID = @"ARIntercomAppID";
NSString * const ARIntercomAPIKey = @"ARIntercomAPIKey";
NSString * const ARKeenProjectID = @"ARKeenProjectID";
NSString * const ARKeenWriteKey = @"ARKeenWriteKey";
NSString * const ARKeenReadKey = @"ARKeenReadKey";
NSString * const ARAdobeData = @"ARAdobeData";
NSString * const ARAdobeSettings = @"ARAdobeSettings";
NSString * const ARInstallTrackerApplicationID = @"ARInstallTrackerApplicationID";
NSString * const ARAppseeAPIKey = @"ARAppseeAPIKey";
NSString * const ARMobileAppTrackerAdvertiserID = @"ARMobileAppTrackerAdvertiserID";
NSString * const ARMobileAppTrackerConversionKey = @"ARMobileAppTrackerConversionKey";
NSString * const ARMobileAppTrackerAllowedEvents = @"ARMobileAppTrackerAllowedEvents";
NSString * const ARLaunchKitAPIToken = @"ARLaunchKitAPIToken";
