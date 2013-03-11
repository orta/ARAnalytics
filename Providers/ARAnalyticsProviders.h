//
//  ARAnalyticsProviders.h
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#ifdef AR_TESTFLIGHT_EXISTS
#import "TestFlight.h"
#import "TestFlightProvider.h"
#endif

#ifdef AR_MIXPANEL_EXISTS
#import "Mixpanel.h"
#import "MixpanelProvider.h"
#endif

#ifdef AR_LOCALYTICS_EXISTS
#import "LocalyticsSession.h"
#import "LocalyticsProvider.h"
#endif

#ifdef AR_FLURRY_EXISTS
#import "Flurry.h"
#import "FlurryProvider.h"
#endif

#ifdef AR_GOOGLEANALYTICS_EXISTS
#import "GAI.h"
#import "GoogleAnalyticsProvider.h"
#endif

#ifdef AR_KISSMETRICS_EXISTS
#import "KISSMetricsAPI.h"
#import "KISSmetricsProvider.h"
#endif

#ifdef AR_CRITTERCISM_EXISTS
#import "Crittercism.h"
#import "CrittercismProvider.h"
#endif

#ifdef AR_CRASHLYTICS_EXISTS
#import "CrashlyticsProvider.h"
#endif

#ifdef AR_BUGSNAG_EXISTS
#import "Bugsnag.h"
#import "BugsnagProvider.h"
#endif

#ifdef AR_COUNTLY_EXISTS
#import "Countly.h"
#import "CountlyProvider.h"
#endif
