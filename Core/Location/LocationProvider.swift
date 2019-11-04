//
//  LocationProvider.swift
//  CarfieCore
//
//  Created by Christopher Olsen on 9/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import CoreLocation
import Foundation

protocol LocationProviderDelegate: class {
    func locationProvider(_ provider: LocationProvider, didRequestLocationPermissions status: CLAuthorizationStatus)
}

protocol LocationProvider {
    /*weak*/ var delegate: LocationProviderDelegate? { get set }
    
    var locationManager: CLLocationManager { get }
    var multicastDelegate: MulticastNotifier<CLLocation> { get }
    
    func requestLocationPermissions()
    func startUpdatingLocation()

    func registerForLocationUpdates(_ observer: AnyObject, locationUpdated: @escaping (CLLocation) -> Void)
    func unregisterForLocationUpdates(_ observer: AnyObject)
}

extension LocationProvider {
    func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        startLocationUpdates(for: CLLocationManager.authorizationStatus())
    }
    
    func registerForLocationUpdates(_ observer: AnyObject, locationUpdated: @escaping (CLLocation) -> Void) {
        multicastDelegate.subscribe(observer, withBlock: locationUpdated)
    }

    func unregisterForLocationUpdates(_ observer: AnyObject) {
        multicastDelegate.remove(observer)
    }
    
    func startLocationUpdates(for authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted, .notDetermined:
            locationManager.stopUpdatingLocation()
        default:
            locationManager.stopUpdatingLocation()
        }
    }
}
