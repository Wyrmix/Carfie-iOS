//
//  DistanceFilteredLocationProvider.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/3/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import CoreLocation

/// Location Provider that only updates location when the distance filter is exceeded. The default distance filter
/// for the shared singleton instance is 200 meters.
final class DistanceFilteredLocationProvider: NSObject, LocationProvider {

    static let shared = DistanceFilteredLocationProvider(distanceFilter: 200)

    weak var delegate: LocationProviderDelegate?

    let locationManager: CLLocationManager

    let multicastDelegate: MulticastNotifier<CLLocation>

    init(locationManager: CLLocationManager = CLLocationManager(), distanceFilter: CLLocationDistance) {
        self.locationManager = locationManager
        multicastDelegate = MulticastNotifier()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = distanceFilter
    }
}

// MARK: - CLLocationManagerDelegate
extension DistanceFilteredLocationProvider: CLLocationManagerDelegate {
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
