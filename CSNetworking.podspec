Pod::Spec.new do |s|

s.name         = 'CSNetworking'
s.summary      = 'On the basis of AFNetworking encapsulation.'
s.version      = '1.0.1'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.authors      = { 'CoderXSLee' => '1363852560@qq.com' }
# s.social_media_url = 'http://'
s.homepage     = 'https://github.com/CoderXSLee/CSNetworking'
s.platform     = :ios, '7.0'
s.ios.deployment_target = '7.0'
s.source       = { :git => 'https://github.com/CoderXSLee/CSNetworking.git', :tag => s.version.to_s }

s.requires_arc = true
s.source_files = 'CSNetworking/**/*.{h,m}'
s.public_header_files = 'CSNetworking/*.{h}'

# s.frameworks = 'CoreFoundation', 'CoreGraphics', 'Foundation', 'MobileCoreServices', 'QuartCore', 'Security', 'SystemConfiguration', 'UIKit'

s.dependency 'AFNetworking', '~>3.1.0'
s.dependency 'MJExtension', '~>3.0.13'
s.dependency 'YYCache', '~>1.0.3'

end
