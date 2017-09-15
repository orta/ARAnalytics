Pod::Spec.new do |s|
  s.name         =  'ARAnalytics'
  s.version      =  '5.0.1'
  s.license      =  {:type => 'MIT', :file => 'LICENSE' }
  s.homepage     =  'https://github.com/orta/ARAnalytics'
  s.authors      =  { 'orta' => 'orta.therox@gmail.com', 'Daniel Haight' => "confidence.designed@gmail.com" }
  s.source       =  { :git => 'https://github.com/orta/ARAnalytics.git', :tag => s.version.to_s }
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.7"
  s.social_media_url = "https://twitter.com/orta"
  s.summary      =  'Using subspecs you can define your analytics provider with the same API on iOS and OS X.'
  # s.description is at the bottom as it is partially generated.

  mixpanel         = { :spec_name => "Mixpanel",            :dependency => "Mixpanel" }
  localytics       = { :spec_name => "Localytics",          :dependency => "Localytics",            :ios_deployment_target => "8.0" }
  flurry           = { :spec_name => "Flurry",              :dependency => "Flurry-iOS-SDK" }
  google           = { :spec_name => "GoogleAnalytics",     :dependency => "GoogleAnalytics",       :has_extension => true }
  kissmetrics      = { :spec_name => "KISSmetrics",         :dependency => "KISSmetrics" }
  crittercism      = { :spec_name => "Crittercism",         :dependency => "CrittercismSDK" }
  countly          = { :spec_name => "Countly",             :dependency => "Countly" }
  bugsnag          = { :spec_name => "Bugsnag",             :dependency => "Bugsnag" }
  helpshift        = { :spec_name => "Helpshift",           :dependency => "Helpshift" }
  tapstream        = { :spec_name => "Tapstream",           :dependency => "Tapstream" }
  newRelic         = { :spec_name => "NewRelic",            :dependency => "NewRelicAgent" }
  amplitude        = { :spec_name => "Amplitude",           :dependency => "Amplitude-iOS" }
  hockeyApp        = { :spec_name => "HockeyApp",           :dependency => "HockeySDK-Source" }
  hockeyAppLib     = { :spec_name => "HockeyAppLib",        :dependency => "HockeySDK" }
  parseAnalytics   = { :spec_name => "ParseAnalytics",      :dependency => "Parse",                 :has_extension => true }
  heap             = { :spec_name => "HeapAnalytics",       :dependency => "Heap" }
  chartbeat        = { :spec_name => "Chartbeat",           :dependency => "Chartbeat",             :has_extension => true }
  umeng            = { :spec_name => "UMengAnalytics",      :dependency => "UMengAnalytics" }
  segmentio        = { :spec_name => "Segmentio",           :dependency => [["Analytics", ">= 3"]], :tvos => true}
  swrve            = { :spec_name => "Swrve",               :dependency => "SwrveSDK" }
  yandex           = { :spec_name => "YandexMobileMetrica", :dependency => "YandexMobileMetrica" }
  adjust           = { :spec_name => "Adjust",              :dependency => "Adjust" }
  intercom         = { :spec_name => "Intercom",            :dependency => "Intercom",              :ios_deployment_target => "8.0" }
  librato          = { :spec_name => "Librato" }
  crashlytics      = { :spec_name => "Crashlytics",         :dependency => "Crashlytics" }
  fabric           = { :spec_name => "Fabric",              :dependency => ["Fabric", "Crashlytics"] }
  appsflyer        = { :spec_name => "AppsFlyer",           :dependency => "AppsFlyerFramework" }
  branch           = { :spec_name => "Branch",              :dependency => "Branch" }
  snowplow         = { :spec_name => "Snowplow",            :dependency => "SnowplowTracker" }
  sentry           = { :spec_name => "Sentry",              :dependency => "Raven" }
  keen             = { :spec_name => "Keen",                :dependency => "KeenClient" }
  adobe            = { :spec_name => "Adobe",               :dependency => "AdobeMobileSDK" }
  installtracker   = { :spec_name => "InstallTracker",      :dependency => "InstallTracker"}
  appsee           = { :spec_name => "Appsee",              :dependency => "Appsee" }
  mobileapptracker = { :spec_name => "MobileAppTracker",    :dependency => "MobileAppTracker"}
  launchkit        = { :spec_name => "LaunchKit",           :dependency => "LaunchKit" }
  firebase         = { :spec_name => "Firebase",            :dependency => "Firebase/Core" }
  leanplum         = { :spec_name => "Leanplum",            :dependency => "Leanplum-iOS-SDK"}
  appboy           = { :spec_name => "Appboy",              :dependency => "Appboy-iOS-SDK"}

  kissmetrics_mac = { :spec_name => "KISSmetricsOSX",  :dependency => "KISSmetrics",            :osx => true,  :provider => "KISSmetrics" }
# countly_mac     = { :spec_name => "CountlyOSX",      :dependency => "Countly",                :osx => true,  :provider => "Countly" }
  mixpanel_mac    = { :spec_name => "MixpanelOSX",     :dependency => "Mixpanel-OSX-Community", :osx => true,  :provider => "Mixpanel"}
  hockeyApp_mac   = { :spec_name => "HockeyAppOSX",    :dependency => "HockeySDK-Mac",          :osx => true,  :provider => "HockeyAppOSX"}
  parseAnalytics_mac = { :spec_name => "ParseAnalyticsOSX", :dependency => "Parse",             :osx => true,  :provider => "ParseAnalytics", :has_extension => true }


  all_analytics = [mixpanel, localytics, flurry, google, kissmetrics, crittercism, crashlytics, fabric, bugsnag, countly, helpshift, kissmetrics_mac, mixpanel_mac, tapstream, newRelic, amplitude, hockeyApp, hockeyAppLib, hockeyApp_mac, parseAnalytics, parseAnalytics_mac, heap, chartbeat, umeng, librato, segmentio, swrve, yandex, adjust, appsflyer, branch, snowplow, sentry, intercom, keen, adobe, installtracker, appsee, mobileapptracker, launchkit, firebase, leanplum, appboy]

  # To make the pod spec API cleaner, subspecs are "iOS/KISSmetrics"

  s.subspec "CoreMac" do |ss|
    ss.source_files = ['*.{h,m}', 'Providers/ARAnalyticalProvider.{h,m}', 'Providers/ARAnalyticsProviders.h']
    ss.exclude_files = ['ARDSL.{h,m}', 'ARNavigationControllerDelegateProxy.{h,m}']
    ss.platform = :osx
  end

  s.subspec "CoreIOS" do |ss|
    ss.source_files = ['*.{h,m}', 'Providers/ARAnalyticalProvider.{h,m}', 'Providers/ARAnalyticsProviders.h']
    ss.exclude_files = ['ARDSL.{h,m}']
    ss.private_header_files = 'ARNavigationControllerDelegateProxy.h'
    ss.tvos.deployment_target = '9.0'
	  ss.ios.deployment_target = '8.0'
  end

  s.subspec "DSL" do |ss|
    ss.source_files = ['ARDSL.{h,m}']
    ss.dependency 'RSSwizzle', '~> 0.1.0'
    ss.dependency 'ReactiveObjC', '~> 2.0'
  end

  # for the description
  all_ios_names = []
  all_osx_names = []

  # make specs for each analytics
  all_analytics.each do |analytics_spec|
    s.subspec analytics_spec[:spec_name] do |ss|

      if analytics_spec[:ios_deployment_target]
        ss.ios.deployment_target = analytics_spec[:ios_deployment_target]
      end

      providername = analytics_spec[:provider]? analytics_spec[:provider] : analytics_spec[:spec_name]

      # Each subspec adds a compiler flag saying that the spec was included
      ss.prefix_header_contents = "#define AR_#{providername.upcase}_EXISTS 1"
      sources = ["Providers/#{providername}Provider.{h,m}"]

      # It there's a category adding extra class methods to ARAnalytics
      if analytics_spec[:has_extension]
        sources << "Extensions/*+#{providername}.{h,m}"
      end

      # only add the files for the osx / iOS version
      if analytics_spec[:osx]
        ss.osx.source_files = sources
        ss.dependency 'ARAnalytics/CoreMac'
        ss.platform = :osx
        all_osx_names << providername

      else
        ss.ios.source_files = sources
        ss.dependency 'ARAnalytics/CoreIOS'
        if analytics_spec[:tvos]
          ss.tvos.source_files = sources
          ss.ios.deployment_target = "6.0"
          ss.tvos.deployment_target = "9.0"
        else
          ss.platform = :ios
        end
        all_ios_names << providername
      end

      # If there's a podspec dependency include it
      Array(analytics_spec[:dependency]).each do |dep|
          ss.dependency *dep
      end

    end
  end


  # If both HockeyApp and Crittercism are included there will be a build failure as they both import the same library (PLCrashReporter).
  # We create two subspecs which contain all the subspecs possible, including HockeyApp or Crittercism in each.
  # Setting one of these as default_subspec allows us to install all libraries possible (if no subspecs are defined) without causing a build failure.
  # User can finetune by specifying subspecs if they wish to include any subset of analytics as normal.

  # create an array of clashing subspecs.
  clashing_subspecs = [hockeyApp, crittercism]

  # cycle through clashing subspecs, removing all but the the one we want to form non_clashing array
  clashing_subspecs.each do |keep_subspec|
    non_clash = all_analytics
    clashing_subspecs.each do |clashing|
      if clashing != keep_subspec then non_clash.delete(clashing) end
    end

    # now for each group of non_clashing subspecs, create a subspec which has these as dependancies.
    s.subspec "no_clash_#{keep_subspec[:spec_name]}" do |ss|
      non_clash.each do |analytics_spec|
        if analytics_spec[:osx]
          ss.osx.dependency "ARAnalytics/#{analytics_spec[:spec_name]}"
        else
          if analytics_spec[:tvos]
            ss.tvos.dependency "ARAnalytics/#{analytics_spec[:spec_name]}"
          end
          ss.ios.dependency "ARAnalytics/#{analytics_spec[:spec_name]}"
        end
      end
    end
  end

  # set default subspec no_clash_NAME where NAME is the subspec we want to use.
  # This will give us all possible subspecs that do not clash with NAME.
  s.default_subspec = 'no_clash_HockeyApp'

  # I always forget to keep the description up to date as provider support is added and removed, thus automation.

  ios_spec_names = all_ios_names[0...-1].join(", ") + " and " + all_ios_names[-1]
  osx_spec_names = all_osx_names[0...-1].join(", ") + " and " + all_osx_names[-1]
  s.description  =  "ARAnalytics is a analytics abstraction library offering a sane API for tracking events and user data. It currently supports on iOS: #{ ios_spec_names }. And for OS X: #{ osx_spec_names }. It does this by using CocoaPods subspecs to let you decide which libraries you'd like to use. You are free to also use the official API for any provider too. Also, comes with an amazing DSL to clear up your methods."

end
