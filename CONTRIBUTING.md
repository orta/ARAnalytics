
## Team members

Orta Therox - [@orta](http://twitter.com/orta)

## Help Out

My code style is somewhere inbetween Github's and Google's. I prefer my `{`'s on the same line, underscore all instance variables and use `#pragma mark` to mark out sections of code. If you're really that interested I wrote about the code standards at [art.sy](http://artsy.github.com/blog/2012/08/14/on-objective-c-code-standards/)

I take Pull Requests. I'm English, so I'm polite and I'll happily discuss any problems, ideas or features people are interested in. 

##How can I add another Analytics choice?

###Adding your library to the subspecs

When you call `pod "ARAnalytics/TestFlight"` you're only specifically asking for a pod subspec in the [ARAnalytics podspec](https://github.com/orta/ARAnalytics/blob/master/ARAnalytics.podspec). In the Spec you can see the ruby hashes for each of the current analytical engines `ARAnalytics` supports. Adding a new one involves creating a new reference in the spec.

``` ruby
  testflight_sdk = { spec_name: "TestFlight",       dependency: "TestFlightSDK",            import_file: "TestFlight" }
  mixpanel       = { spec_name: "Mixpanel",         dependency: "Mixpanel",                 import_file: "Mixpanel" }
  localytics     = { spec_name: "Localytics",       dependency: "Localytics",               import_file: "LocalyticsSession" }
```

And then adding that to the array of specs below. This will add `#define AR_#{spec_name.upcase}_EXISTS 1` to the `ARAnalytics+GeneratedHeader.h` as well as a `#import "#{import_file}"` to the file. The dependency is the Cocoapods pod that it corresponds to.

You don't need to include a dependancy, but it definitely makes life easier, if you're interested in that you should look at how I implemented Crashlytics support.


###Implementing in ARAnalytics

I have been making all of the setup methods for the analytics choices available through two methods, their own private setup method like `+ (void)setupFlurryWithAPIKey:(NSString *)key` and through the more general `+ (void)setupWithAnalytics:(NSDictionary *)analyticsDictionary` which makes it easy to setup multiple by using a dictionary. There are keys for each choice at the bottom of `ARAnalytics.m` and externs in `ARAnalytics.h` so that people don't have to look up the specific keys for the dictionary.

Then you should add the functions which your app supports to functions like `+ (void)event:(NSString *)event withProperties:(NSDictionary *)properties` and `+ (void)identifyUserwithID:(NSString *)id andEmailAddress:(NSString *)email`. It might not support all of the features of ARAnalytics or it might do a lot more than ARAnalytics currently has an API for. In either case the features that you do add need to be wrapped in `#ifdef AR_#{spec_name.upcase}_EXISTS` and `#endif` blocks. This will ensure that people who haven't installed the same libraries as you don't get compiler errors.

###Testing the library

When you're working on the Podfile, I used this terminal command to kill all cocoapod caches.

``` bash
rm -rf ~/Library/Caches/CocoaPods; rm pods; rm -rf Podfile.lock; pod install --verbose
```

And would refer to a local Podspec in my podfile like this

``` ruby
pod 'ARAnalytics/Crashlytics', :podspec => 'vendor/ARAnalytics.podspec'
```

I don't have a test harness for ARAnalytics, this is something I've been looking at lately. I'm still a bit green with respect to iOS testing. For now I've just been hooking it up to my live apps and testing with real data.