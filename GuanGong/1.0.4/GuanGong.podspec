#
# Be sure to run `pod lib lint GuanGong.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GuanGong'
  s.version          = '1.0.4'
  s.summary          = '属于第一车网'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/miaoruiyuan/GuanGong'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'miaoruiyuan' => 'miao201110@gmail.com' }
  s.source           = { :git => '/Users/mry/Desktop/GuanGong', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GuanGong/Classes/*.{h,m}'
  
  s.resource_bundles = {
    'GuanGong' => ['GuanGong/Assets']
  }

  s.public_header_files = 'GuanGong/Classes/GGHeader.h'
  s.frameworks = 'UIKit'
  #s.dependency 'YYKit',
end
