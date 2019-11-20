//
//  ProfileRepository.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/19/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol ProfileRepository {
    var profile: CarfieProfile? { get set }
}

struct DefaultProfileRepository: ProfileRepository {
    let key = "com.carfie.profile"
    
    /// Profile for the current logged in user.
    var profile: CarfieProfile? {
        get {
            return retrieveFromDisk()
        }
        set {
            saveToDisk(newValue)
        }
    }
    
    private func retrieveFromDisk() -> CarfieProfile? {
        guard let encodedData = UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        
        guard let profile = try? JSONDecoder().decode(CarfieProfile.self, from: encodedData) else {
            return nil
        }
        
        return profile
    }
    
    private func saveToDisk(_ profile: CarfieProfile?) {
        guard let profile = profile else {
            UserDefaults.standard.set(nil, forKey: key)
            return
        }
        
        let encoder = JSONEncoder()
        guard let encodedData = try? encoder.encode(profile) else {
            assertionFailure("Could not encode Profile object.")
            return
        }
        UserDefaults.standard.set(encodedData, forKey: key)
    }
}
