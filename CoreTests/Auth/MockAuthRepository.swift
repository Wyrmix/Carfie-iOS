//
//  MockAuthRepository.swift
//  CoreTests
//
//  Created by Christopher Olsen on 11/2/19.
//

import Foundation

class MockAuthRepository: AuthRepository {
    var auth: CarfieAuth {
        get {
            return cachedAuth
        }
        set {
            cachedAuth = newValue
        }
    }
    
    var cachedAuth: CarfieAuth = CarfieAuth(accessToken: nil)
}
