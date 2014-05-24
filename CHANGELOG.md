#ARAnalytics

## Version 2.7.2
* Add support for CocoaDocs colours

## Version 2.7.1

* Fixes to Aspect retaining memory management ( thanks @aschuch )

## Version 2.7

* Support for UMeng added ( thanks Cai Guo )
* Fixes to Tapsteam provider
* Fixes for Google Analytics v3 timing events ( thanks @travisyu )

## Version 2.6.0

* New DSL for analytics ( thanks @AshFurrow )
* Updated Heap support ( thanks @confidenceJuice )
* Updates for Google Analytics defaults, and adds error logs when required event keys are skipped ( thanks @amleszk )

## Version 2.5.0

* Support for proxying navigations delegate methods ( thanks @rhodgins )
* Podspec fix for Localytics-iOS-Client ( thanks @amleszk )
* Added a setupProvider function so people can use private API providers ( thanks @suiying )
* Added a removeProvider function.
* Deprecated monitorNavigationViewController for having a typo
* Added tests
* Updated HockeySDK to default to showing updates for everyone on betas
* Added travis support - ( thanks @dlackty )

## Version 2.4.3

* fix for Testflight 2.2.3 ( thanks @KrauseFx )

## Version 2.4.2
* Fixes to Heapshift's API ( thanks MigrantP )

## Version 2.4.1
* Switched pod for Heap analytics ( thanks matinm )

## Version 2.4
* Support for Chartbeat ( thanks @segiddins )

## Version 2.3.4
* Support for Google Analytics' specific event properties when broadcasting to all analytics providers ( thanks @yoiang )

## Version 2.3.3
* Send properties to TestFlight events (thanks @enriquez)

## Version 2.3.2
* Fix for Google Analytics default category ( thanks @hungtruong )

## Version 2.3.1
* Fix for Amplitude Amplitude ( thanks @hungtruong )

## Version 2.3
* Support for Heap Ananlytics ( thanks @daniel1of1 )
* Fixes for Crittercism SDK ( thanks @kreeger )
* Improved Localytics' sending of events ( thanks @jhersh )

## Version 2.2.0
* Support for Parse Analytics ( thanks @Daniel1of1 )

## Version 2.1.1
* ARC! ( thanks @jhersh)
* Improved Hockey & Tapstream support ( thanks @Daniel1of1 )

## Version 2.0
* Support for Google Ananlytics v3 ( thanks @dlackty )

## Version 1.9
* Support for HockeyApp ( thanks @Daniel1of1 )
* Workaround for subspecs that create build confilicts ( thanks @Daniel1of1 )

## Version 1.8
* Support for Amplitude ( thanks @Daniel1of1 )

## Version 1.7
* Support for NewRelic ( thanks @Daniel1of1 )

## Version 1.6
* Support for Tapstream ( thanks @Daniel1of1 )

## Version 1.5.1
* Support for sending NSErrors ( thanks @jk )

## Version 1.5
* Mac support for KISSmetrics, Countly and Mixpanel.

## Version 1.3.1
* Support the new Mixpanel 2.0 API

## Version 1.3
* Deprecated typo'd method for setting user details: `identifyUserwithID` -> `identifyUserWithID` - ( Thanks @ursachec )
* Helpshift support ( thanks @MigrantP )
* Remove reference to UUID by moving to Black Pixels UUID ( thanks again @MigrantP )

### Version 1.2.1
* Track page views on modals/popovers ( thanks @benjaminjackson )

## Version 1.2
* Support for Bugsnap
* Support for Cocoapods 0.17

## Version 1.1

* Support for Countly
* Rewrite into a more modular codebase
* Supports more features of Google Analytics 
* Supports using custom Mixpanel URLS ( thanks gabrielrinaldi )

## Version 1.0

* Supports TestFlight, Mixpanel, Localytics, Flurry, Google Analytics, KISSMetrics, Crittercism and Crashlytics
* Functions for Events, Timer Events
* Support for User Properties
* Allows Navigation Stack Tracking
* Allows External Logging
