//
//  DefaultLocationProvider.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/3/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import CoreLocation

final class DefaultLocationProvider: NSObject, LocationProvider {

    static let shared = DefaultLocationProvider()
    
    weak var delegate: LocationProviderDelegate?

    let locationManager: CLLocationManager

    let multicastDelegate: MulticastNotifier<CLLocation>

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        multicastDelegate = MulticastNotifier()
        super.init()
        locationManager.delegate = self
    }
}

// MARK: - CLLocationManagerDelegate
extension DefaultLocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationProvider(self, didRequestLocationPermissions: status)
        startLocationUpdates(for: status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        multicastDelegate.notify(withResult: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}
