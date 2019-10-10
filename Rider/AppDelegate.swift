

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
    static let shared = AppDelegate()

    private let authController = DefaultAuthController.shared
    private let rootContainerInteractor = RootContainerInteractor()
    
    private var shouldShowLogin = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        FirebaseApp.configure()
        setAppearance()
        self.google()
        self.IQKeyboard()
        self.siri()
        self.registerPush(forApp: application)
        self.stripe()
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
        rootContainerInteractor.delegate = self
        
        window?.rootViewController = rootContainerInteractor.rootViewController
        
        let loginViewController = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.LaunchViewController)
        rootContainerInteractor.configureLoginViewController(loginViewController)
        
        let mainViewController = Common.setDrawerController()
        rootContainerInteractor.configureChildViewController(mainViewController)
        
        if shouldShowLogin {
            window?.makeKeyAndVisible()
            // Do not animate present on initial launch
            rootContainerInteractor.presentLoginExperience(animated: false)
        } else {
            rootContainerInteractor.start()
            window?.makeKeyAndVisible()
        }
    }
}

extension AppDelegate: RootContainerInteractorDelegate {
    func onboardingDidComplete() {
        rootContainerInteractor.dismissLoginExperience()
    }
}

extension AppDelegate {
    
    // MARK:- Appearance
    private func setAppearance() {
        if let languageStr = UserDefaults.standard.value(forKey: Keys.list.language) as? String, let language = Language(rawValue: languageStr) {
            setLocalization(language: language)
        }else {
            setLocalization(language: .english)
        }
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .darkGray
        var attributes = [NSAttributedString.Key : Any]()
        attributes.updateValue(UIColor.black, forKey: .foregroundColor)
        attributes.updateValue(UIFont(name: FontCustom.Bold.rawValue, size: 16.0)!, forKey : NSAttributedString.Key.font)
        UINavigationBar.appearance().titleTextAttributes = attributes
        attributes.updateValue(UIFont(name:FontCustom.Medium.rawValue, size: 18.0)!, forKey : NSAttributedString.Key.font)
        UINavigationBar.appearance().largeTitleTextAttributes = attributes
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
        UIPageControl.appearance().currentPageIndicatorTintColor = .primary
        UIPageControl.appearance().backgroundColor = .clear
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
    
    private func siri() {
        
        if INPreferences.siriAuthorizationStatus() != .authorized {
            INPreferences.requestSiriAuthorization { (status) in
                print("Is Siri Authorized  -",status == .authorized)
            }
        }
    }
    
    //MARK:- Stripe
    
    private func stripe(){
        
        STPPaymentConfiguration.shared().publishableKey = stripePublishableKey
        
    }
}

// MARK:- Reachability

extension AppDelegate {
    
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


