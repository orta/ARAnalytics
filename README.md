ARAnalytics v1.6
================

ARAnalytics is to iOS what [Analytical](https://github.com/jkrall/analytical) is to ruby, or [Analytics.js](http://segmentio.github.com/analytics.js/) is to javascript.

ARAnalytics is a Cocoapods only library, which provides a sane API for tracking events and some simple user data. We currently support for iOS: TestFlight, Mixpanel, Localytics, Flurry, Google Analytics, KISSMetrics, Tapstream, Countly, Crittercism, Bugsnag, Helpshift and Crashlytics. And for OS X: KISSmetrics, Countly and Mixpanel. It does this by using subspecs from CocoaPods 0.17+ to let you decide which libraries you'd like to use.


[Changelog](https://github.com/orta/ARAnalytics/blob/master/CHANGELOG.md)  

Installation
=====
If you want to include all the options, just use: `pod "ARAnalytics"`

If you're looking to use one or more the syntax is one per line.

``` ruby
  pod "ARAnalytics/Crashlytics"
  pod "ARAnalytics/Mixpanel"
```

Usage
=====

Setup
----

Once you've `pod installed`'d the libraries you can either use the individual (for example) `[ARAnalytics setupTestFlightWithTeamToken:@"TOKEN"]` methods to start up each indiviual analytics platform or use the generic setupWithAnalytics with our constants.

``` objc
  [ARAnalytics setupWithAnalytics:@{
      ARCrittercismAppID : @"KEY",
      ARKISSMetricsAPIKey : @"KEY",
      ARGoogleAnalyticsID : @"KEY"
   }];
```

Logging
----
Submit a console log that is stored online, for crash reporting this provides a great way to provide breadcrumbs. `ARLog(@"Looked at Artwork (%@)", _artwork.name);`

``` objc
extern void ARLog (NSString *format, ...);
```

Event Tracking
----
``` objc
/// Submit user events
+ (void)event:(NSString *)event;
+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties;

/// Let ARAnalytics deal with the timing of an event
+ (void)startTimingEvent:(NSString *)event;
+ (void)finishTimingEvent:(NSString *)event;
```

Error Tracking
----
``` objc
/// Submit errors to providers
+ (void)error:(NSError *)error;
+ (void)error:(NSError *)error withMessage:(NSString *)message;
```

User Properties
----
``` objc
/// Set a per user property
+ (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email;
+ (void)setUserProperty:(NSString *)property toValue:(NSString *)value;
+ (void)incrementUserProperty:(NSString*)counterName byInt:(int)amount;
```

Page View Tracking
----
``` objc
/// Monitor Navigation changes as page view
+ (void)pageView:(NSString *)pageTitle;
+ (void)monitorNavigationViewController:(UINavigationController *)controller;
```

Contributing
====
See [Contributing](https://github.com/orta/ARAnalytics/blob/master/CONTRIBUTING.md)

Upcoming Features / Things people can help with
=====

* Support for [HockeyKit](https://github.com/TheRealKerni/HockeyKit),  [QuincyKit](https://github.com/TheRealKerni/QuincyKit) and [HockeyApp](http://hockeyapp.net). Or any other analytical provider not mentioned.
