
## Team members

Orta Therox - [@orta](http://twitter.com/orta)
Daniel Haight - [@daniel1of1](http://twitter.com/daniel1of1)

## Help Out

My code style is somewhere inbetween Github's and Google's. I prefer my `{`'s on the same line, underscore all instance variables and use `#pragma mark` to mark out sections of code. If you're really that interested I wrote about the code standards at [art.sy](http://artsy.github.com/blog/2012/08/14/on-objective-c-code-standards/)

I take Pull Requests. I'm English, so I'm polite and I'll happily discuss any problems, ideas or features people are interested in. 

##How can I add another Analytics provider?

###Adding your library to the subspecs

When you call `pod "ARAnalytics/TestFlight"` you're only specifically asking for a pod subspec in the [ARAnalytics podspec](https://github.com/orta/ARAnalytics/blob/master/ARAnalytics.podspec). In the Spec you can see the ruby hashes for each of the current analytical engines `ARAnalytics` supports. Adding a new one involves creating a new reference in the spec.

``` ruby
  testflight_sdk = { spec_name: "TestFlight",       dependency: "TestFlightSDK" }
  mixpanel       = { spec_name: "Mixpanel",         dependency: "Mixpanel" }
  localytics     = { spec_name: "Localytics",       dependency: "Localytics" }
```

And then adding that to the array of specs below. This will add `#define AR_#{spec_name.upcase}_EXISTS 1` to the `ARAnalytics+GeneratedHeader.h` as well as a `#import "#{import_file}"` to the file. The dependency is the Cocoapods pod that it corresponds to.

You don't need to include a dependancy, but it definitely makes life easier, if you're interested in that you should look at how I implemented Crashlytics support.


###Implementing in ARAnalytics

I have been making all of the setup methods for the analytics choices available through two methods, their own private setup method like `+ (void)setupFlurryWithAPIKey:(NSString *)key` and through the more general `+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary` which makes it easy to setup multiple by using a dictionary. There are keys for each choice at the bottom of `ARAnalytics.m` and externs in `ARAnalytics.h` so that people don't have to look up the specific keys for the dictionary.

Each analytical provider is a subclass of ARAnalyticalProvider, they can optionally respond to different calls from the ARAnalytics shared instance. These methods are below.

```objc
- (id)initWithIdentifier:(NSString *)identifier;

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email;
- (void)setUserProperty:(NSString *)property toValue:(NSString *)value;
- (void)event:(NSString *)event withProperties:(NSDictionary *)properties;
- (void)incrementUserProperty:(NSString *)counterName byInt:(NSNumber *)amount;
- (void)error:(NSError *)error withMessage:(NSString *)message;
- (void)didShowNewViewController:(UIViewController *)controller;
- (void)logTimingEvent:(NSString *)event withInterval:(NSNumber *)interval;
- (void)remoteLog:(NSString *)parsedString;
```

As providers have different APIs its the job of the provider subclass to try and map the ARAnalytics API to the provider's API. Some APIs require some trickery, others are more obvious and some are forbidden. It'd be up to you as an API provider subclass-er to figure it out. You can always create a partial pull request for discussion.

###Testing the library

When you're working on the Podfile, I used this terminal command to kill all cocoapod caches.

``` bash
rm -rf ~/Library/Caches/CocoaPods; rm -rf pods; rm Podfile.lock; pod install --verbose
```

And would refer to a local Podspec in my podfile like this

``` ruby
pod 'ARAnalytics/Crashlytics', :local => '../ARAnalytics'
```

I don't have a test harness for ARAnalytics, this is something I've been looking at lately. I'm still a bit green with respect to iOS testing. For now I've just been hooking it up to my live apps and testing with real data.