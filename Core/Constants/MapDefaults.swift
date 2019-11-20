//
//  Map.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/19/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import CoreLocation

struct MapDefaults {
    
    /// The default location for the map. Coordinates are for Dallas, TX. Hopefully once the map is refactored to not need a default location
    /// this can be removed.
    static let defaultLocation = CLLocationCoordinate2D(latitude: 32.776805, longitude: -96.799000)
}
