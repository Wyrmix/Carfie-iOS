
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
    
    private let authController = DefaultAuthController.shared(.driver)
    private let profileController = CarfieProfileController()
    
    /// The root interactor for the app. Coordinates presenting and navgigating through the onboarding,
    /// login, and main view controllers of the app.
    /// Force unwrapped for convenience. IF this property doesn't exist the app won't work anyway.
    private var rootContainerInteractor: RootContainerInteractor!
    private var shouldShowLogin = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.appearence()
        CarfieAppearance.configureTheme(.driver)
        self.setgoogleMap()
        setGoogleSignIn()
        
        Router.configure()
        
        // This needs to be called to load User data which is used to determine Auth state. This is very bad.
        // It also returns a boolean that is used to determine if we should show login/onboarding. This is some
        // serious tech debt that needs to be addressed soon.
        //
        // If user data does not exist we will show login.
        shouldShowLogin = !retrieveUserData()
        
        syncProfile()
        
        configureRootInteractor()

        registerForLocationUpdates()
        self.checkUpdates()
        return true
    }
}

// MARK: - Root ViewController configuration and login
extension AppDelegate {
    private func configureRootInteractor() {
        rootContainerInteractor = RootContainerInteractor(welcomeConfiguration: DriverWelcomeConfiguration(postLoginHandler: { profile in
            Common.storeUserData(from: profile)
            // Tech-Debt: Only Carfie login exists currently. This login will need to be addressed eventually when social login is added.
            User.main.loginType = LoginType.manual.rawValue
            storeInUserDefaults()
        }))
        rootContainerInteractor.delegate = self
        
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
        rootContainerInteractor.dismissOnboardingExperience()
    }
}

// MARK: - Profile
extension AppDelegate {
    private func syncProfile() {
        guard !shouldShowLogin else { return }
        profileController.fetchProfile(theme: .driver) { _ in }
    }
}

// MARK: - Location Updates
extension AppDelegate {
    func registerForLocationUpdates() {
        DistanceFilteredLocationProvider.shared.registerForLocationUpdates(self) { location in
            BackGroundTask.backGroundInstance.userStoredDetail.latitude = location.coordinate.latitude
            BackGroundTask.backGroundInstance.userStoredDetail.lontitude = location.coordinate.longitude
        }
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
        let token = deviceToken.map({ String(format: "%02.2hhx", $0) }).joined()
        profileController.updateAPNSToken(token, theme: .driver) { result in
            switch result {
            case .success:
                // We don't really care about success. There's nothing to show to the user.
                // Maybe at some point this will be used to kick off listeners for pushes or something.
                break
            case .failure:
                // TODO: maybe some sort of retry?
                break
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}
}
