
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

    private let authController = DefaultAuthController.shared
    var window: UIWindow?
    var locationManager:CLLocationManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.appearence()
        self.setgoogleMap()
        registerPush(forApp: application)
        setGoogleSignIn()
        stripe()
        let navigationController =  Router.setWireFrame()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        initiateLocationManager()
        self.checkUpdates()
        return true
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
