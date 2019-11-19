//
//  ProfileController.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/19/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum ProfileControllerError: Error {
    case noCachedProfile
}

/// A facade layer for all Profile calls. Helps manage persistence and adds convenience to many profile calls.
protocol ProfileController {
    
    /// Get the User's profile information. Retrieve's from disk if available.
    /// - Parameter theme: current app target
    /// - Parameter completion: called on completion with success or failure
    func getProfile(theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void)
    
    /// Fetches the user profile from the server only. Forces an update of the cache with what is on the server.
    /// - Parameter theme: current app target
    /// - Parameter completion: called on completion with success or failure
    func fetchProfile(theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void)
    
    /// Update the User's profile.
    /// - Parameter profile: object with updated information
    /// - Parameter theme: current app target
    /// - Parameter completion: called on completion with success or failure
    func updateProfile(_ profile: CarfieProfile, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void)
    
    /// Update the User's social security number. This is only valid for the Driver app.
    /// - Parameter ssn: SSN to add
    /// - Parameter completion: called on completion with success or failure
    func updateSSN(_ ssn: String, completion: @escaping (Result<CarfieProfile>) -> Void)
}

class CarfieProfileController: ProfileController {
    
    private let profileService: ProfileService
    private var profileRepository: ProfileRepository
    
    init(
        profileService: ProfileService = DefaultProfileService(),
        profileRepository: ProfileRepository = DefaultProfileRepository()
    ) {
        self.profileService = profileService
        self.profileRepository = profileRepository
    }
    
    func getProfile(theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
        guard let profile = profileRepository.profile else {
            fetchProfile(theme: theme, completion: completion)
            return
        }
        
        completion(.success(profile))
    }
    
    func fetchProfile(theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
        profileService.getProfile(theme: theme) { result in
            switch result {
            case .success(let profile):
                self.profileRepository.profile = profile
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
    
    func updateProfile(_ profile: CarfieProfile, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
//        profileService.updateProfile(profile, theme: theme) { result in
//            switch result {
//            case .success(let profile):
//                self.profileRepository.profile = profile
//                completion(result)
//            case .failure:
//                completion(result)
//            }
//        }
    }
    
    func updateSSN(_ ssn: String, completion: @escaping (Result<CarfieProfile>) -> Void) {
        guard var profile = profileRepository.profile else {
            completion(.failure(ProfileControllerError.noCachedProfile))
            return
        }
        
        profile.ssn = ssn
        
        updateProfile(profile, theme: .driver) { result in
            completion(result)
        }
    }
}
