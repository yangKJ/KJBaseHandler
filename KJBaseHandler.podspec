Pod::Spec.new do |s|
  s.name     = "KJBaseHandler"
  s.version  = "0.0.2"
  s.summary  = "77 KJBaseHandler"
  s.homepage = "https://github.com/yangKJ/KJBaseHandler"
  s.license  = "MIT"
  s.license  = {:type => "MIT", :file => "LICENSE"}
  s.license  = "Copyright (c) 2020 yangkejun"
  s.author   = { "77" => "393103982@qq.com" }
  s.platform = :ios
  s.source   = {:git => "https://github.com/yangKJ/KJBaseHandler.git",:tag => "#{s.version}"}
  s.social_media_url = 'https://www.jianshu.com/u/c84c00476ab6'
  s.requires_arc = true

  s.default_subspec = 'Base'
  s.ios.source_files = 'KJBaseHandler/KJBaseHeader.h'
  s.resources = "README.md"

  s.subspec 'Base' do |y|
    y.source_files = "KJBaseHandler/Base/**/**/*.{h,m}"
    y.frameworks = 'Foundation','UIKit'
  end

  s.subspec 'Tool' do |fun|
    fun.source_files = "KJBaseHandler/Tool/**/*.{h,m}"
    fun.public_header_files = 'KJBaseHandler/Tool/*.h',"KJBaseHandler/Tool/**/*.h"
    fun.dependency 'KJBaseHandler/Base'
  end
  
  s.subspec 'Router' do |ro|
    ro.source_files = "KJBaseHandler/Router/**/*.{h,m}"
    ro.dependency 'KJBaseHandler/Base'
  end

  s.dependency 'KJExtensionHandler'
  
end


