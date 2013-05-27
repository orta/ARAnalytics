Pod::Spec.new do |s|
  s.name         =  'ARAnalytics'
  s.version      =  '1.5'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      =  'Use multiple major analytics platforms with one clean API.'
  s.homepage     =  'http://github.com/orta/ARAnalytics'
  s.authors      =  { 'orta' => 'orta.therox@gmail.com' }
  s.source       =  { :git => 'https://github.com/orta/ARAnalytics.git', :tag => s.version.to_s }
  s.description  =  'Using subspecs you can define your analytics provider with the same API on iOS and OS X.'

  testflight_dependencies = ["TestFlightSDK", "BPXLUUIDHandler"]
  testflight_sdk = { :spec_name => "TestFlight",       :dependency => testflight_dependencies,    :import_file => "TestFlight" }
  mixpanel       = { :spec_name => "Mixpanel",         :dependency => "Mixpanel",                 :import_file => "Mixpanel" }
  localytics     = { :spec_name => "Localytics",       :dependency => "Localytics",               :import_file => "LocalyticsSession" }
  flurry         = { :spec_name => "Flurry",           :dependency => "FlurrySDK",                :import_file => "Flurry" }
  google         = { :spec_name => "GoogleAnalytics",  :dependency => "GoogleAnalytics-iOS-SDK",  :import_file => "GAI", :has_extension => true }
  kissmetrics    = { :spec_name => "KISSmetrics",      :dependency => "KISSmetrics",              :import_file => "KISSMetricsAPI" }
  crittercism    = { :spec_name => "Crittercism",      :dependency => "CrittercismSDK",           :import_file => "Crittercism" }
  countly        = { :spec_name => "Countly",          :dependency => "Countly",                  :import_file => "Countly" }
  bugsnag        = { :spec_name => "Bugsnag",          :dependency => "Bugsnag",                  :import_file => "Bugsnag" }
  helpshift      = { :spec_name => "Helpshift",        :dependency => "Helpshift",                :import_file => "Helpshift" }
  crashlytics    = { :spec_name => "Crashlytics" }
  
  kissmetrics_mac = { :spec_name => "KISSmetricsOSX",  :dependency => "KISSmetrics",            :import_file => "KISSMetricsAPI", :osx => true,  :provider => "KISSmetrics" }
  countly_mac     = { :spec_name => "CountlyOSX",      :dependency => "Countly",                :import_file => "Countly" ,       :osx => true,  :provider => "Countly" }
  mixpanel_mac    = { :spec_name => "MixpanelOSX",     :dependency => "Mixpanel-OSX-Community", :import_file => "Mixpanel",       :osx => true,  :provider => "Mixpanel"}
  
  $all_analytics = [testflight_sdk, mixpanel, localytics, flurry, google, kissmetrics, crittercism, crashlytics, bugsnag, countly, helpshift, kissmetrics_mac, countly_mac, mixpanel_mac]

  # To make the pod spec API cleaner, I've changed the subspecs to be "iOS/KISSmetrics"
  s.subspec "Core" do |ss|
    ss.source_files =  ['*.{h,m}', 'Providers/ARAnalyticalProvider.{h,m}', 'Providers/ARAnalyticsProviders.h']
    ss.platforms = [:osx, :ios]
  end
  
  # make specs for each analytics
  $all_analytics.each do |analytics_spec|
    s.subspec analytics_spec[:spec_name] do |ss|
      
      ss.dependency 'ARAnalytics/Core'
      
      providername = analytics_spec[:provider]? analytics_spec[:provider] : analytics_spec[:spec_name]

      # Each subspec adds a compiler flag saying that the spec was included
      ss.prefix_header_contents = "#define AR_#{providername.upcase}_EXISTS 1"      
      sources = ["Providers/#{providername}Provider.{h,m}"]

      # It there's a category adding extra class methods to ARAnalytics
      if analytics_spec[:has_extension]
        sources << "Extensions/ARAnalytics+#{analytics_spec[:spec_name]}.{h,m}"
      end

      # only add the files for the osx / iOS version
      if analytics_spec[:osx]
        ss.osx.source_files = sources
      else   
        ss.ios.source_files = sources
      end

      # If there's a podspec dependency include it
      if analytics_spec[:dependency]
        if analytics_spec[:dependency].is_a? Array
          analytics_spec[:dependency].each do |dep|
            ss.dependency dep
          end

        else
          ss.dependency analytics_spec[:dependency]
        end
      end
      
    end
  end
end
