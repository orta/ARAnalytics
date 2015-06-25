ARAnalytics v3.X.Y [![Build Status](https://travis-ci.org/orta/ARAnalytics.svg?branch=master)](https://travis-ci.org/orta/ARAnalytics)
================

ARAnalytics is to iOS what [Analytical](https://github.com/jkrall/analytical) is to ruby, or [Analytics.js](http://segmentio.github.com/analytics.js/) is to javascript.

ARAnalytics is a analytics abstraction library offering a sane API for tracking events and user data. It currently supports on iOS: Mixpanel, Localytics, Flurry, GoogleAnalytics, KISSmetrics, Crittercism, Crashlytics, Fabric, Bugsnag, Countly, Helpshift, Tapstream, NewRelic, Amplitude, HockeyApp, HockeyAppLib, ParseAnalytics, HeapAnalytics, Chartbeat, UMengAnalytics, Librato, Segmentio, Swrve, YandexMobileMetrica, Adjust, AppsFlyer, Branch, Snowplow, Sentry, Intercom, Keen and Adobe. And for OS X: KISSmetrics, Mixpanel and HockeyApp. It does this by using CocoaPods subspecs to let you decide which libraries you'd like to use. You are free to also use the official API for any provider too. Also, comes with an amazing DSL to clear up your methods.

It does this by using CocoaPods subspecs to let you decide which libraries you'd like to use. You are free to also use the official API for any provider too. Also, comes with an amazing [DSL](#aspect-oriented-dsl) to clear up your methods.

[Changelog](https://github.com/orta/ARAnalytics/blob/master/CHANGELOG.md)

Integration
=====
You shouldn't just use: `pod "ARAnalytics"`. Since CocoaPods 0.36+ you should do something like:

``` ruby
  pod "ARAnalytics", :subspecs => ["Mixpanel", "Segmentio", "HockeyApp"]
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

// Add extra properties to get sent along with every event
+ (void)addEventSuperProperties:(NSDictionary *)superProperties;


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

Aspect-Oriented DSL
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
      },
      @{
          ARAnalyticsEventName: @"switch switched",
          ARAnalyticsSelectorName: NSStringFromSelector(@selector(switchSwitched:)),
      }]
   },
   ...
```

The above configuration specifies that the "button pressed" event be sent whenever the selector `buttonPressed:` is invoked on *any* instance of `MyViewController`. Additionally, every view controller will send a page view with its title as the page name whenever `viewDidAppear:` is called. There are also advanced uses using blocks in the DSL to selectively disable certain events, or to provide event property dictionaries.

```objc
[ARAnalytics setupWithAnalytics: @{ /* keys */ } configuration: @{
  ARAnalyticsTrackedEvents: @[ @{
    ARAnalyticsClass: MyViewController.class,
    ARAnalyticsDetails: @[ 
      @{
        ARAnalyticsEventName: @"button pressed",
        ARAnalyticsSelectorName: NSStringFromSelector(@selector(buttonPressed:)),
        ARAnalyticsShouldFire: ^BOOL(MyViewController *controller, NSArray *parameters) {
          return /* some condition */;
        },
        ARAnalyticsEventProperties: ^NSDictionary*(MyViewController *controller, NSArray *parameters) {
          return @{ /* Custom properties */ };
        }
      },
      /* more events for this class */
    ]
  },
  ...
```

Note that when using page tracking on `UIViewControllers`, *all* instances *must* have a non-`nil` value for their `title` property. If your app uses nested view controllers, that may not be the case. In this instance, use the `ARAnalyticsShouldFire` block to disable these view controllers from firing analytics events. 

```objc
ARAnalyticsShouldFire: ^BOOL(MyViewController *controller, NSArray *parameters) {
  return controller.title != nil;
},
```

HockeyApp
----

Starting with HockeyApp version 3.7.0, the HockeyApp provider will automatically keep logs of events and include those in crash reports, thus adding ‘breadcrumbs’ to your report and hopefully providing helpful context for your crash reports. Any messages logged with `ARLog()` will also get included in the report.

Note, however, that on iOS `syslogd` will not keep logs around for a long time, as such you should only expect logs of people that re-start the application immediately after the application crashing.


Full list of subspecs
----

iOS: `Mixpanel`, `Localytics`, `Flurry`, `GoogleAnalytics`, `KISSmetrics`, `Crittercism`, `Countly`, `Bugsnag`, `Helpshift`, `Tapstream`, `NewRelic`, `Amplitude`, `HockeyApp`, `HockeyAppLib`, `ParseAnalytics`, `HeapAnalytics`, `Chartbeat`, `UMengAnalytics`, `Segmentio`, `Swrve`, `YandexMobileMetrica`, `Adjust`, `Intercom`, `Librato`, `Crashlytics`, `Fabric`, `AppsFlyer`, `Branch`, `Snowplow`, `Sentry`, `Keen` & `Adobe`.

OSX: `KISSmetricsOSX`, `HockeyAppOSX` & `MixpanelOSX`.


Contributing, or adding a new analytics provider
====
See [Contributing](https://github.com/orta/ARAnalytics/blob/master/CONTRIBUTING.md)
