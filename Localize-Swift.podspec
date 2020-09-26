Pod::Spec.new do |s|
  s.name             = "Localize-Swift"
  s.version          = "3.2.0"
  s.summary          = "Swift-friendly localization and i18n syntax with in-app language switching."
  s.description      = <<-DESC
                      A simple framework that improves localization and i18n in Swift apps with cleaner syntax and in-app language switching.
                     DESC

  s.homepage         = "https://github.com/marmelroy/Localize-Swift"
  s.license          = 'MIT'
  s.author           = { "Roy Marmelstein" => "marmelroy@gmail.com" }
  s.source           = { :git => "https://github.com/marmelroy/Localize-Swift.git", :tag => s.version.to_s, :submodules => true}
  s.social_media_url   = "http://twitter.com/marmelroy"

  s.swift_version = '5.3'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.3' }
  s.requires_arc = true

  s.subspec 'LocalizeSwiftCore' do |core|
    core.ios.deployment_target = '9.0'
    core.osx.deployment_target = '10.9'
    core.tvos.deployment_target = '9.0'
    core.watchos.deployment_target = '2.0'
    core.source_files = "Sources/*.{swift}"
  end

  s.subspec 'UIKit' do |ui|
    ui.dependency 'Localize-Swift/LocalizeSwiftCore'
    ui.ios.deployment_target = '9.0'
    ui.source_files = 'Sources/UI/'
  end

end
