
Pod::Spec.new do |s|
  s.name         =  'ARAnalytics'
  s.version      =  '1.3'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      =  'Simplify your analytics choices.'
  s.homepage     =  'http://github.com/orta/ARAnalytics'
  s.author       =  { 'orta' => 'orta.therox@gmail.com' }
  s.source       =  { :git => 'https://github.com/orta/ARAnalytics.git', :commit => 'HEAD' }
  s.description  =  'Using subspecs you can define your analytics provider with the same API.'
  s.platform     =  :ios
  s.source_files =  ['*.{h,m}', 'Providers/*.{h,m}']

  testflight_sdk = { :spec_name => "TestFlight",       :dependency => "TestFlightSDK"           }
  mixpanel       = { :spec_name => "Mixpanel",         :dependency => "Mixpanel"                }
  localytics     = { :spec_name => "Localytics",       :dependency => "Localytics"              }
  flurry         = { :spec_name => "Flurry",           :dependency => "FlurrySDK"               }
  google         = { :spec_name => "GoogleAnalytics",  :dependency => "GoogleAnalytics-iOS-SDK" }
  kissmetrics    = { :spec_name => "KISSmetrics",      :dependency => "KISSmetrics"             }
  crittercism    = { :spec_name => "Crittercism",      :dependency => "CrittercismSDK"          }
  countly        = { :spec_name => "Countly",          :dependency => "Countly"                 }
  bugsnag        = { :spec_name => "Bugsnag",          :dependency => "Bugsnag"                 }
  crashlytics    = { :spec_name => "Crashlytics" }

  $all_analytics =  [testflight_sdk, mixpanel, localytics, flurry, google, kissmetrics, crittercism, crashlytics, bugsnag, countly]
  
  # make specs for each analytics
  $all_analytics.each do |analytics_spec|
    s.subspec analytics_spec[:spec_name] do |ss|
  
      # Each subspec adds a compiler flag saying that the spec was included
      ss.compiler_flags = "#{analytics_spec[:spec_name].upcase}_EXISTS=1"
      
      # If there's a podspec dependency include that
      if analytics_spec[:dependency] 
        ss.dependency analytics_spec[:dependency]
      end
      
    end
  end
  
end
