Pod::Spec.new do |s|
  s.name = "GuanGong"
  s.version = "1.0.3"
  s.summary = "\u{5c5e}\u{4e8e}\u{7b2c}\u{4e00}\u{8f66}\u{7f51}"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"miaoruiyuan"=>"miao201110@gmail.com"}
  s.homepage = "https://github.com/miaoruiyuan/GuanGong"
  s.description = "TODO: Add long description of the pod here."
  s.frameworks = "UIKit"
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/GuanGong.framework'
end
