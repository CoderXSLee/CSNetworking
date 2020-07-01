Pod::Spec.new do |s|

s.name         = 'CSNetworking'
s.summary      = 'On the basis of AFNetworking encapsulation.'
s.version      = '2.0.1'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.authors      = { 'CoderXSLee' => '1363852560@qq.com' }
# s.social_media_url = 'http://'
s.homepage     = 'https://github.com/CoderXSLee/CSNetworking'
s.platform     = :ios, '9.0'
s.ios.deployment_target = '9.0'
s.source       = { :git => 'https://github.com/CoderXSLee/CSNetworking.git', :tag => s.version.to_s }

s.requires_arc = true
s.source_files = 'CSNetworking/**/*.{h,m}'
s.public_header_files = 'CSNetworking/*.{h}'
s.resource     = 'CSNetworking/CSTip.bundle'

# s.frameworks = 'CoreFoundation', 'CoreGraphics', 'Foundation', 'MobileCoreServices', 'QuartCore', 'Security', 'SystemConfiguration', 'UIKit'

s.dependency 'AFNetworking'
s.dependency 'MJExtension'
s.dependency 'YYCache'

end
