#
# Be sure to run `pod lib lint PhoneNumberKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Interpolate"
  s.version          = "0.1.4"
  s.summary          = "Swift interpolation framework for gesture-driven animations."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
                        Interpolate is a Swift interpolation framework for creating interactive gesture-driven animations..
                       DESC

  s.homepage         = "https://github.com/marmelroy/Interpolate"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Roy Marmelstein" => "marmelroy@gmail.com" }
  s.source           = { :git => "https://github.com/marmelroy/Interpolate.git", :tag => s.version.to_s }
  s.social_media_url   = "http://twitter.com/marmelroy"

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true

  s.source_files = "Interpolate"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'QuartzCore', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
