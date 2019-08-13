# Uncomment the next line to define a global platform for your project

platform :ios, '8.0'
source 'https://github.com/cocoapods/specs.git'
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'
source 'http://gitlab.anniu-inc.com/frontend/iOS_pods/QLPodSpec.git'

targetNameArray = [
"Emergency",
]

def emergencypods

# third sdk
pod 'IQKeyboardManager', '~> 5.0.6'
pod 'MJExtension'
pod 'Masonry'
pod 'MJRefresh'
pod 'SFHFKeychainUtils','0.0.1'
pod 'FMDB'
pod 'WebViewJavascriptBridge',  '~>6.0.2'
pod 'MJRefresh'
pod 'QLCreditPod' ,:git => 'git@gitlab.anniu-inc.com:frontend/iOS_pods/QLCreditPod.git',:commit=>'8840203fc2417428ee6ec8dcdaa8ac81dccf1c3e', :subspecs=>['Common','LocationModule']

pod 'AMapNavi'
pod 'AMapLocation'
pod 'AMapSearch'

end

post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
config.build_settings['BITCODE_GENERATION_MODE'] = 'bitcode'
config.build_settings['ENABLE_BITCODE'] = 'NO'
end
end
end

targetNameArray.each do |targetName|
target :"#{targetName}" do
emergencypods
end
end
