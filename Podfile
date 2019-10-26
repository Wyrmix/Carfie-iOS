platform :ios, '11.0'

use_frameworks!

abstract_target 'Apps' do
    pod 'AccountKit', '~> 4.35.0'
    pod 'Alamofire'
    pod 'Crashlytics', '~> 3.14.0'
    pod 'Fabric', '~> 1.10.2'
    pod 'FacebookLogin'
    pod 'FirebaseAnalytics', '~> 4.0.0'
    pod 'Firebase/Auth'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Messaging'
    pod 'Firebase/Storage'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'GoogleSignIn'
    pod 'IHKeyboardAvoiding'
    pod 'ImagePicker'
    pod 'KWDrawerController'
    pod 'Lightbox'
    pod 'lottie-ios'
    pod 'PopupDialog'
    pod 'Stripe', '~> 13.2'

    target 'Rider' do
        pod 'DateTimePicker'
        pod 'IQKeyboardManagerSwift'
    end

    target 'Driver' do
        pod 'EFAutoScrollLabel'
        pod 'HCSStarRatingView', '~> 1.5'
    end

    abstract_target 'CarfieTests' do
        pod 'Nimble'
        pod 'Quick'
        
        target 'CoreTests'

        target 'DriverTests' do
            inherit! :search_paths
        end

        target 'RiderTests' do
            inherit! :search_paths
        end
    end
end
