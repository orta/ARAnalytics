![art.sy](https://raw.github.com/orta/ARAnalytics/master/web/headline.jpg "Art.sy | ARAnalytics")

ARAnalytics
================

ARAnalytics is to iOS what [Analytical](https://github.com/jkrall/analytical) is to ruby, or [Analytics.js](http://segmentio.github.com/analytics.js/) is to javascript.

ARAnalytics is a Cocoapods only library, which provides a sane API for tracking events and some simple user data. We currently support: Testflight, Mixpanel, Localytics, Flurry, Google Analytics, KISSMetrics, Crittercism and Crashlytics. It does this by using CocoaPods subspecs to let you define which libraries you'd like to use.

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
      ARCrittercismKey : @"KEY",
      ARKISSMetricsKey : @"KEY",
      ARGoogleAnalyticsKey : @"KEY"
   }];
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

User Properties
----
``` objc
/// Set a per user property
+ (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email;
+ (void)addUserProperty:(NSString *)property toValue:(NSString *)value;
```

Navigation Stack Tracking
----
``` objc
/// Monitor Navigation changes as page view
+ (void)monitorNavigationViewController:(UINavigationController *)controller;
````

Upcoming
=====

I'd like to get in support for [HockeyKit](https://github.com/TheRealKerni/HockeyKit),  [QuincyKiy](https://github.com/TheRealKerni/QuincyKit) and [HockeyApp](http://hockeyapp.net).