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
    func updateProfile(_ profile: CarfieProfile, completion: @escaping (Result<CarfieProfile>) -> Void)
    
    /// Update the User's vehicle and identification info. This is only valid for the Driver app.
    /// - Parameter identification: info to update
    /// - Parameter completion: called on completion with success or failure
    func updateDriverIdentification(_ identification: DriverIdentification, completion: @escaping (Result<CarfieProfile>) -> Void)
    
    /// Update the user's device's APNS token.
    /// - Parameters:
    ///   - token: the APNS token
    ///   - Parameter theme: current app target
    ///   - completion: called on completion with success or failure
    func updateAPNSToken(_ token: String, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void)
    
    func updateBasicProfileInfo(_ info: BasicProfileInfo, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void)
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
    
    func updateProfile(_ profile: CarfieProfile, completion: @escaping (Result<CarfieProfile>) -> Void) {
        profileService.updateProfile(profile) { result in
            switch result {
            case .success(let profile):
                self.profileRepository.profile = profile
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
    
    func updateDriverIdentification(_ identification: DriverIdentification, completion: @escaping (Result<CarfieProfile>) -> Void) {
        profileService.updateDriverIdentification(identification) { result in
            switch result {
            case .success:
                // POSTs to profile return a stripped down profile object that does not contain everything. To keep
                // profile in sync with the server we'll perform a background fetch on success.
                self.fetchProfile(theme: .driver) { result in }
            case .failure:
                break
            }
            
            completion(result)
        }
    }
    
    func updateAPNSToken(_ token: String, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
        let apnsData = APNSData(deviceToken: token)
        
        profileService.updateAPNSData(apnsData, theme: theme) { result in
            completion(result)
        }
    }
    
    func updateBasicProfileInfo(_ info: BasicProfileInfo, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
        guard var profile = profileRepository.profile else { return }
        
        profile.firstName = info.firstName
        profile.lastName = info.lastName
        profile.email = info.email
        profile.mobile = info.mobile
        
        updateProfile(profile) { result in
            completion(result)
        }
    }
}
