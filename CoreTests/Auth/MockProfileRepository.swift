//
//  MockProfileRepository.swift
//  CoreTests
//
//  Created by Christopher Olsen on 11/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class MockProfileRepository: ProfileRepository {
    var profile: CarfieProfile? {
        get {
            return cachedProfile
        }
        set {
            cachedProfile = newValue
        }
    }
    
    var cachedProfile: CarfieProfile? = nil
}
