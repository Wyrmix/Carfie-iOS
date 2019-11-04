//
//  LocationPermissionsInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/3/19.
//

import CoreLocation
import UIKit
import UserNotifications

class LocationPermissionsInteractor {
    weak var viewController: LocationPermissionsViewController?
    
    private var locationProvider: LocationProvider
    
    init(locationProvider: LocationProvider = DistanceFilteredLocationProvider.shared) {
        self.locationProvider = locationProvider
    }
    
    func requestLocationPermissions() {
        // set delegate right before requesting so we don't get any false positives (e.g. the delegate callback that occurs on CLLocationManager creation.)
        locationProvider.delegate = self
        locationProvider.requestLocationPermissions()
    }
    
    private func requestPushNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]) { [weak self] (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self?.viewController?.onboardingDelegate?.onboardingScreenComplete()
            }
        }
    }
}

extension LocationPermissionsInteractor: LocationProviderDelegate {
    func locationProvider(_ provider: LocationProvider, didRequestLocationPermissions status: CLAuthorizationStatus) {
        requestPushNotificationPermissions()
    }
}
