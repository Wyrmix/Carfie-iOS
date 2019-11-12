

//
//  AppDelegate.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import CoreData
import Intents
import Crashlytics
import Fabric
import Firebase
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var reachability : Reachability?

    private let authController = DefaultAuthController.shared(.rider)
    
    /// The root interactor for the app. Coordinates presenting and navgigating through the onboarding,
    /// login, and main view controllers of the app.
    /// Force unwrapped for convenience. IF this property doesn't exist the app won't work anyway.
    private var rootContainerInteractor: RootContainerInteractor!
    
    private var shouldShowLogin = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        FirebaseApp.configure()
        setAppearance()
        CarfieAppearance.configureTheme(.rider)
        self.google()
        self.IQKeyboard()
        Router.configure()
        
        // This needs to be called to load User data which is used to determine Auth state. This is very bad.
        // It also returns a boolean that is used to determine if we should show login/onboarding. This is some
        // serious tech debt that needs to be addressed soon.
        //
        // If user data does not exist we will show login.
        shouldShowLogin = !retrieveUserData()
        
        configureRootInteractor()
         DispatchQueue.global(qos: .background).async {
            self.startReachabilityChecking()
         }
         self.checkUpdates()
        
         return true
    }
    
    // MARK:- Core Data
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (descriptionString, error) in
            
            print("Error in Context  ",error ?? "")
        })
        return container
    }()
}

// MARK: - Root ViewController configuration and login
extension AppDelegate {
    private func configureRootInteractor() {
        rootContainerInteractor = RootContainerInteractor(welcomeConfiguration: RiderWelcomeConfiguration(postLoginHandler: { profile in
            Common.storeUserData(from: profile)
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
            // Do not animate present on initial launch
            rootContainerInteractor.presentOnboardingExperience()
        } else {
            rootContainerInteractor.start()
        }
    }
    
    func onboardingDidComplete() {
        rootContainerInteractor.dismissOnboardingExperience()
    }
}

extension AppDelegate {
    
    // MARK:- Appearance
    private func setAppearance() {
        setLocalization(language: .english)
        
        // disable Dark Mode in iOS 13
        if #available(iOS 13, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    // MARK:- Check Update
    private func checkUpdates() {
        
        var request = ChatPush()
        request.version = Bundle.main.getVersion()
        request.device_type = .ios
        request.sender = .user
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
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
       // Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
       // Messaging.messaging().apnsToken = deviceToken
        deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Apn Token ", deviceToken.map { String(format: "%02.2hhx", $0) }.joined())
    }

//    func application(_ application: UIApplication,
//                     didReceiveRemoteNotification notification: [AnyHashable : Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        
//        print("Notification  :  ", notification)
//        completionHandler(.newData)
//        
//    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
         print("Error in Notification  \(error.localizedDescription)")
    }
    
    
}
    
    // MARK:- Google
    
extension AppDelegate {
    
    private func google(){
        
        GMSServices.provideAPIKey(CarfieKey.googleMaps)
        GMSPlacesClient.provideAPIKey(CarfieKey.googleMaps)

        guard let clientId = FirebaseApp.app()?.options.clientID else {
            fatalError("Firebase client id not found")
        }
        
        authController.configureGoogleSignIn(with: clientId)
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return authController.handleGoogleAuthUrl(url)
    }
    
    private func IQKeyboard() {
        IQKeyboardManager.shared.enable = false
    }
}

// MARK:- Reachability

extension AppDelegate {
    // MARK:- Offline Booking on No Internet Connection
    
    func startReachabilityChecking() {
        
        self.reachability = Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityAction), name: NSNotification.Name.reachabilityChanged, object: nil)
      //  self.reachability?.startNotifier()
        do {
            try self.reachability?.startNotifier()
        } catch let err {
            print("Error in Reachability", err.localizedDescription)
        }
    }
    

    func stopReachability() {
        // MARK:- Stop Reachability
        self.reachability?.stopNotifier()
    }
    
    // MARK:- Reachability Action
    
    @objc private func reachabilityAction(notification : Notification) {
        
        print("Reachability \(self.reachability?.connection.description ?? .Empty)", #function)
        guard self.reachability != nil else { return }
        if self.reachability!.connection == .none && riderStatus == .none {
            if let rootView = UIApplication.shared.keyWindow?.rootViewController?.children.last, rootView.children.count > 0 , (rootView.children.last is HomeViewController), retrieveUserData() {
                rootView.present(id: Storyboard.Ids.OfflineBookingViewController, animation: true)
            }
        } else {
            (UIApplication.topViewController() as? OfflineBookingViewController)?.dismiss(animated: true, completion: nil)
        }
    }
    
}


