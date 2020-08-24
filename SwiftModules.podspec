#
# Be sure to run `pod lib lint SwiftModules.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftModules'
  s.version          = '0.1.0'
  s.summary          = '关于iOS Swift的一些模块私有库.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Include "分类，网络请求，工具方法", Support the Objective - C language.
                       DESC

  s.homepage         = 'https://github.com/aichiko0225/SwiftModules'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ash' => 'aichiko66@163.com' }
  s.source           = { :git => 'https://github.com/aichiko0225/SwiftModules.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/aichiko0225'

  s.static_framework = true
  s.ios.deployment_target = '10.0'
  s.default_subspecs = 'Extensions', 'Services', 'RxComponents'
  # s.source_files = 'SwiftModules/Classes/**/*'

  s.swift_version = ['5.0', '4.0', '4.2']
  s.frameworks='Foundation','UIKit'

  # subspec
  s.subspec 'Extensions' do |ss|
    ss.source_files = 'SwiftModules/Extensions/**/*.swift'
    
    # 混淆view 的声明周期
    ss.subspec 'Swizzled' do |sss|
      sss.source_files = 'SwiftModules/Extensions/Swizzled/*.swift'
    end
    # dependency
    ss.dependency "SwifterSwift"
  end
  
  s.subspec 'Services' do |ss|
    ss.source_files = 'SwiftModules/Services/**/*.swift'
    # dependency
    ss.dependency "Moya"
    ss.dependency "SwiftyJSON"
    ss.dependency "YYCache"
  end

  # RxComponents
  s.subspec 'RxComponents' do |ss|
    ss.source_files = 'SwiftModules/RxComponents/**/*.swift'
    
    ss.dependency "RxSwift"
    ss.dependency "RxCocoa"
    ss.dependency "RxDataSources"
  end
  
  # s.resource_bundles = {
  #   'SwiftModules' => ['SwiftModules/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'

  # Logger
  s.dependency 'SwiftyBeaver'
end
