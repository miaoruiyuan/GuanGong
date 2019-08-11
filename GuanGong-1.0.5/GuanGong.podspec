Pod::Spec.new do |s|
  s.name = "GuanGong"
  s.version = "1.0.5"
  s.summary = "diyichewang"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"miaoruiyuan"=>"miao201110@gmail.com"}
  s.homepage = "https://github.com/miaoruiyuan/GuanGong"
  s.description = "TODO: Add long description of the pod here."
  s.frameworks = ["UIKit", "AVFoundation", "Foundation"]
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/GuanGong.embeddedframework/GuanGong.framework'
end
