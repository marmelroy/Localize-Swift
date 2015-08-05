Pod::Spec.new do |s|
  s.name         = "Localize-Swift"
  s.version      = "0.0.1"
  s.summary      = "In-app language switching and better syntax for Swift i18n -  work in progress"
  s.description  = "Swift framework that improves i18n and localization with cleaner syntax and in-app language switching."
  s.homepage     = "https://github.com/marmelroy/Localize-Swift"
  s.license      = "MIT"
  s.author             = { "Roy Marmelstein" => "hello@roysapps.com" }
  s.social_media_url   = "http://twitter.com/marmelroy"
  s.source       = { :git => "https://github.com/marmelroy/Localize-Swift.git", :commit => "feb8c0b89289a01bc54871466e1bfbf395f59a82" }
  s.source_files = "Localize.swift"
  s.platform = :ios
  s.ios.deployment_target = "8.0"
  s.requires_arc = true
end
