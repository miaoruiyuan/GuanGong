#
# Be sure to run `pod lib lint GuanGong.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GuanGong'
  s.version          = '1.0.6'
  s.summary          = '第一车网的关二爷'

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
  s.source           = { :git => 'https://github.com/miaoruiyuan/GuanGong.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.prefix_header_file = 'GuanGong/Classes/GGPrefixHeader.pch'
  s.source_files = 'GuanGong/Classes/**/*.{h,m,pch,plist,json,c}'
#  s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}

#   s.resource_bundles = {
#     'GuanGong' => ['GuanGong/Classes/Assets.xcassets/*.png']
#   }

  s.public_header_files = 'GuanGong/Classes/**/*.h'
  s.static_framework = true
  s.frameworks = 'UIKit', 'AVFoundation', 'Foundation','UserNotifications'
  s.libraries = 'c++', 'z','sqlite3'
  s.vendored_libraries = 'GuanGong/Classes/libWeChatSDK.a'

#  s.vendored_frameworks = [
#  'GuanGong/Classes/Framework/',
#  'SOCRLib/Classes/framework/'
#  ]

  s.dependency 'FMDB'
  s.dependency 'MBProgressHUD'
  s.dependency 'AFNetworking'
  s.dependency 'YYKit'
  s.dependency 'MJRefresh'
  s.dependency 'Masonry'
  s.dependency 'BlocksKit'
  s.dependency 'IQKeyboardManager'
  s.dependency 'QBImagePickerController'
  s.dependency 'ReactiveObjC'
  s.dependency 'CYLTabBarController'
  s.dependency 'DZNEmptyDataSet'
  s.dependency 'WZLBadge'
  s.dependency 'JDStatusBarNotification'
  s.dependency 'UITableView+FDTemplateLayoutCell'
  s.dependency 'Qiniu'
  s.dependency 'PNChart'
  s.dependency 'SDCycleScrollView'
  s.dependency 'UMCCommon'
  s.dependency 'UMessage'
  s.dependency 'UMCAnalytics'
  
  
  
end
