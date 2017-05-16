Pod::Spec.new do |s|
s.name             = 'TCScreenShotTools'
s.version          = '1.0.0'
s.summary          = '模仿摩拜单车截图分享功能'
s.homepage         = 'https://github.com/itanchao/TCScreenShotTools'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'itanchao' => 'itanchao@gmail.com' }
s.source           = { :git => 'https://github.com/itanchao/TCScreenShotTools.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '9.0'

s.source_files = 'TCScreenShotTools/Classes/**/*'
#s.resource_bundle = 'TCScreenShotTools/Assets/**/*'
s.resource_bundles = {
   'TCScreenShotTools' => ['TCScreenShotTools/Assets/*.png']
}

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
