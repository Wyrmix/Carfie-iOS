//
//  AuthRepository.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/2/19.
//

import Foundation

protocol AuthRepository {
    var auth: CarfieAuth { get set }
}

struct DefaultAuthRepository: AuthRepository {
    let key = "com.carfie.rider.auth"
    
    /// Current auth object that will contain the user's Carfie API access token if they are logged in.
    var auth: CarfieAuth {
        get {
            return retrieveFromDisk()
        }
        set {
            saveToDisk(newValue)
        }
    }
    
    private func retrieveFromDisk() -> CarfieAuth {
        guard let encodedData = UserDefaults.standard.object(forKey: key) as? Data else {
            // If nothing is in the repository return a default object.
            return CarfieAuth(accessToken: nil)
        }
        
        guard let auth = try? JSONDecoder().decode(CarfieAuth.self, from: encodedData) else {
            return CarfieAuth(accessToken: nil)
        }
        
        return auth
    }
    
    private func saveToDisk(_ auth: CarfieAuth) {
        let encoder = JSONEncoder()
        guard let encodedData = try? encoder.encode(auth) else {
            assertionFailure("Could not encode Auth object.")
            return
        }
        UserDefaults.standard.set(encodedData, forKey: key)
    }
}
