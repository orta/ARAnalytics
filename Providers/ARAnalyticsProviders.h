//
//  ARAnalyticsProviders.h
//  ARAnalyticsTests
//
//  Created by orta therox on 05/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#ifdef AR_TESTFLIGHT_EXISTS
#import "TestFlightProvider.h"
#endif

#ifdef AR_MIXPANEL_EXISTS
#import "MixpanelProvider.h"
#endif

#ifdef AR_LOCALYTICS_EXISTS
#import "LocalyticsProvider.h"
#endif

#ifdef AR_FLURRY_EXISTS
#import "FlurryProvider.h"
#endif

#ifdef AR_GOOGLEANALYTICS_EXISTS
#import "GoogleAnalyticsProvider.h"
#import "ARAnalytics+GoogleAnalytics.h"
#endif

#ifdef AR_KISSMETRICS_EXISTS
#import "KISSmetricsProvider.h"
#endif

#ifdef AR_CRITTERCISM_EXISTS
#import "CrittercismProvider.h"
#endif

#ifdef AR_CRASHLYTICS_EXISTS
#import "CrashlyticsProvider.h"
#endif

#ifdef AR_BUGSNAG_EXISTS
#import "BugsnagProvider.h"
#endif

#ifdef AR_COUNTLY_EXISTS
#import "CountlyProvider.h"
#endif

#ifdef AR_HELPSHIFT_EXISTS
#import "HelpshiftProvider.h"
#endif

#ifdef AR_TAPSTREAM_EXISTS
#import "TapstreamProvider.h"
#endif

#ifdef AR_NEWRELIC_EXISTS
#import "NewRelicProvider.h"
#endif

#ifdef AR_AMPLITUDE_EXISTS
#import "AmplitudeProvider.h"
#endif

#ifdef AR_HOCKEYAPP_EXISTS
#import "HockeyAppProvider.h"
#endif

#ifdef AR_PARSEANALYTICS_EXISTS
#import "ParseAnalyticsProvider.h"
#endif

#ifdef AR_HEAPANALYTICS_EXISTS
#import "HeapAnalyticsProvider.h"
#endif

#ifdef AR_CHARTBEAT_EXISTS
#import "ChartbeatProvider.h"
#endif

#ifdef AR_UMENGANALYTICS_EXISTS
#import "UMengAnalyticsProvider.h"
#endif
