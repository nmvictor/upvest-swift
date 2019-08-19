
Pod::Spec.new do |s|

  s.name             = "Upvest"
  s.version          = "1.0.0"
  s.summary          = "Swift library for the Upvest API."
  s.homepage         = "http://www.upvest.co"
  s.license          = "MIT"
  s.author           = { "Victor Moin'" => "victormn20@gmail.com" }

  s.platform         = :ios
  s.swift_version    = '5.0'
  s.platforms        = { :ios => "8.0" }
  s.source           = { :git => 'https://github.com/upvest/upvest-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.7"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source_files  = "Sources", "Sources/**/*.swift"
  s.exclude_files = "Tests"

  s.requires_arc    = true
  s.default_subspec    = "Core"
  s.subspec "Core" do |ss|
    ss.source_files  = "Sources/**/*.swift"
    ss.framework  = "Foundation"
  end
end
