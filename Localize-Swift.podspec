Pod::Spec.new do |s|
  s.name         = "Localize-Swift"
  s.version      = "0.0.2"
  s.summary      = "In-app language switching and better syntax for Swift i18n -  work in progress"
  s.description  = "Swift framework that improves i18n and localization with cleaner syntax and in-app language switching."
  s.homepage     = "https://github.com/marmelroy/Localize-Swift"
  s.license      = "MIT"
  s.author             = { "Roy Marmelstein" => "hello@roysapps.com" }
  s.social_media_url   = "http://twitter.com/marmelroy"
  s.source       = { :git => "https://github.com/marmelroy/Localize-Swift.git", :tag => "0.0.2" }
  s.source_files = "Localize"
  s.platform = :ios
  s.ios.deployment_target = "8.0"
  s.requires_arc = true
end
