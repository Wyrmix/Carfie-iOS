
//
//  AppDelegate.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Firebase
import GoogleMaps
import Stripe
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager:CLLocationManager!
    
    private let authController = DefaultAuthController.shared
    private let rootContainerInteractor = RootContainerInteractor()
    
    private var shouldShowLogin = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.appearence()
        self.setgoogleMap()
        registerPush(forApp: application)
        setGoogleSignIn()
        stripe()
        
        Router.configure()
        
        // This needs to be called to load User data which is used to determine Auth state. This is very bad.
        // It also returns a boolean that is used to determine if we should show login/onboarding. This is some
        // serious tech debt that needs to be addressed soon.
        //
        // If user data does not exist we will show login.
        shouldShowLogin = !retrieveUserData()
        
        configureRootInteractor()

        initiateLocationManager()
        self.checkUpdates()
        return true
    }
}

// MARK: - Root ViewController configuration and login
extension AppDelegate {
    private func configureRootInteractor() {
        rootContainerInteractor.delegate = self
        
        let welcomeConfiguration = WelcomeConfiguration()
        
        let onboardingInteractor = OnboardingInteractor(onboardingViewControllers: welcomeConfiguration.viewControllers)
        onboardingInteractor.delegate = rootContainerInteractor
        rootContainerInteractor.configureOnboardingNavigationController(OnboardingNavigationController.navigationController(for: onboardingInteractor))
        
        let loginViewController = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.LaunchViewController)
        rootContainerInteractor.configureLoginViewController(loginViewController)
        
        let mainViewController = Common.setDrawerController()
        rootContainerInteractor.configureChildViewController(mainViewController)
        
        rootContainerInteractor.configureRootViewController(RootViewController())
    }
}

// MARK: - RootContainerInteractorDelegate
extension AppDelegate: RootContainerInteractorDelegate {
    func rootViewIsLoaded() {
        window?.rootViewController = rootContainerInteractor.rootViewController
        window?.makeKeyAndVisible()
        
        if shouldShowLogin {
            rootContainerInteractor.presentOnboardingExperience()
        } else {
            rootContainerInteractor.start()
        }
    }
    
    func onboardingDidComplete() {
        rootContainerInteractor.dismissLoginExperience()
    }
}

extension AppDelegate {
    
    //MARK:- Appearence
    private func appearence() {
        
        if let languageStr = UserDefaults.standard.value(forKey: Keys.list.language) as? String, let language = Language(rawValue: languageStr) {
            setLocalization(language: language)
        } else {
            setLocalization(language: .english)
        }
        
        // disable Dark Mode in iOS 13
        if #available(iOS 13, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .darkGray
        var attributes = [NSAttributedString.Key : Any]()
        attributes.updateValue(UIColor.black, forKey: .foregroundColor)
        attributes.updateValue(UIFont(name: "Avenir-Heavy", size: 16)!, forKey : NSAttributedString.Key.font)
        UINavigationBar.appearance().titleTextAttributes = attributes
        attributes.updateValue(UIFont(name: "Avenir-Heavy", size: 16)!, forKey : NSAttributedString.Key.font)
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = attributes
        }
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
        UIPageControl.appearance().currentPageIndicatorTintColor = .primary
        UIPageControl.appearance().backgroundColor = .clear
    }
    
    
    // MARK:- Register Push
    private func registerPush(forApp application : UIApplication){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    private func setgoogleMap(){
         GMSServices.provideAPIKey(CarfieKey.googleMaps)
    }
    
    private func setGoogleSignIn() {
        FirebaseApp.configure()
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            fatalError("Firebase is not configured")
        }

        authController.configureGoogleSignIn(with: clientId)
    }
    
    //MARK:- Stripe
    
    private func stripe() {
        STPPaymentConfiguration.shared().publishableKey = User.main.stripeKey ?? stripePublishableKey
    }
    
    // MARK:- Check Update
    private func checkUpdates() {
        var request = ChatPush()
        request.version = Bundle.main.getVersion()
        request.device_type = .ios
        request.sender = .provider
        Webservice().retrieve(api: .versionCheck, url: nil, data: request.toData(), imageData: nil, paramters: nil, type: .POST) { (error, data) in
            guard let responseObject = data?.getDecodedObject(from: ChatPush.self),
                  let forceUpdate = responseObject.force_update,
                  forceUpdate,
                  let appUrl = responseObject.url,
                  let urlObject = URL(string: appUrl),
                  UIApplication.shared.canOpenURL(urlObject)
            else {
                return
            }
            
            func showUpdateUI() {
              DispatchQueue.main.async {
                    let alert = showAlert(message: Constants.string.newVersionAvailableMessage.localize(), handler: { (_) in
                        UIApplication.shared.open(urlObject, options: [:], completionHandler: nil)
                        showUpdateUI()
                    })
                    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                }
            }
            showUpdateUI()
        }
    }
}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return authController.handleGoogleAuthUrl(url)
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}
    
    func initiateLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension AppDelegate: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationCordinates : CLLocationCoordinate2D = (manager.location?.coordinate)!
        BackGroundTask.backGroundInstance.userStoredDetail.latitude = locationCordinates.latitude
        BackGroundTask.backGroundInstance.userStoredDetail.lontitude = locationCordinates.longitude
    }
}
