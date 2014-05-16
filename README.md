ARAnalytics v2.7.1 [![Build Status](https://travis-ci.org/orta/ARAnalytics.svg?branch=master)](https://travis-ci.org/orta/ARAnalytics)
================

ARAnalytics is to iOS what [Analytical](https://github.com/jkrall/analytical) is to ruby, or [Analytics.js](http://segmentio.github.com/analytics.js/) is to javascript.

ARAnalytics is a analytics abstraction library offering a sane API for tracking events and user data. It currently supports on iOS: TestFlight, Mixpanel, Localytics, Flurry, GoogleAnalytics, KISSmetrics, Crittercism, Crashlytics, Bugsnag, Countly, Helpshift, Tapstream, NewRelic, Amplitude, HockeyApp, ParseAnalytics, HeapAnalytics and Chartbeat. And for OS X: KISSmetrics and Mixpanel. It does this by using CocoaPods subspecs to let you decide which libraries you'd like to use. You are free to also use the official API for any provider too. Also, comes with an amazing [DSL](#dsl) to clear up your methods.

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

Once you've `pod installed`'d the libraries you can either use the individual (for example) `[ARAnalytics setupTestFlightWithTeamToken:@"TOKEN"]` methods to start up each individual analytics platform or use the generic setupWithAnalytics with our constants.

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

On top of this you get access to use the original SDK. ARAnalytics provides a common API between lots of providers, so it will try to map most of the functionality between providers, but if you're doing complex things, expect to also use your provider's SDK.

DSL
----
There is also a DSL-like setup constructor in the `ARAnalytics/DSL` subspec that lets you do all of your analytics setup at once. Example usage:

``` objc
[ARAnalytics setupWithAnalytics: @{ /* keys */ } configuration: @{
   ARAnalyticsTrackedScreens: @[ @{
      ARAnalyticsClass: UIViewController.class,
      ARAnalyticsDetails: @[ @{
          ARAnalyticsPageNameKeyPath: @"title",
      }]
  }],
   ARAnalyticsTrackedEvents: @[@{
      ARAnalyticsClass: MyViewController.class,
      ARAnalyticsDetails: @[ @{
          ARAnalyticsEventName: @"button pressed",
          ARAnalyticsSelectorName: NSStringFromSelector(@selector(buttonPressed:)),
      }]
   },
   ...
```

The above configuration specifies that the "button pressed" event be sent whenever the selector `buttonPressed:` is invoked on *any* instance of `MyViewController`. Additionally, every view controller will send a page view with its title as the page name whenever `viewDidAppear:` is called. There are also advanced uses using blocks in the DSL to selectively disable certain events, or to provide event property dictionaries.

``` objc
[ARAnalytics setupWithAnalytics: @{ /* keys */ } configuration: @{
   ARAnalyticsTrackedEvents: @[ @{
    ARAnalyticsClass: MyViewController.class,
    ARAnalyticsDetails: @[ @{
        ARAnalyticsEventName: @"button pressed",
        ARAnalyticsSelectorName: NSStringFromSelector(@selector(buttonPressed:)),
        ARAnalyticsShouldFire: ^BOOL(MyViewController *controller, RACTuple *parameters) {
            return /* some condition */;
        },
        ARAnalyticsEventProperties: ^NSDictionary*(MyViewController *controller, RACTuple * parameters) {
            return @{ /* Custom properties */ };
        }
    }]
},
...
```

Contributing
====
See [Contributing](https://github.com/orta/ARAnalytics/blob/master/CONTRIBUTING.md)
