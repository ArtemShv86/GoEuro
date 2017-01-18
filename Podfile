platform :ios, "8.0"

workspace 'GoEuro.xcworkspace'
xcodeproj 'GoEuro.xcodeproj'

use_frameworks!

def shared_pods
	pod 'RxSwift'
	pod 'RxCocoa'
	pod 'SwiftyJSON'
	pod 'Alamofire'
	pod 'RxAlamofire'
end

target 'GoEuro' do
	shared_pods
    pod 'AlamofireImage'
    pod 'HMSegmentedControl'
    pod 'PKHUD'
    pod 'SwiftDate'
end

target 'GoEuroTests' do
	shared_pods
end

target 'GoEuroUITests' do
	shared_pods
end

