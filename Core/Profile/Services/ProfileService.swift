//
//  ProfileService.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/1/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol ProfileService {
    func getProfile(theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void)
    func updateProfile(_ profile: CarfieProfile, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void)
    func updateAPNSData(_ data: APNSData, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void)
}

class DefaultProfileService: ProfileService {
    let service: NetworkService
    
    init(service: NetworkService = DefaultNetworkService()) {
        self.service = service
    }
    
    func getProfile(theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
        let request = GetProfileRequest(theme: theme)
        service.request(request) { result in
            completion(result)
        }
    }
    
    func updateProfile(_ profile: CarfieProfile, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
        let request = UpdateProfileRequest(theme: theme, profile: profile)
        service.request(request) { result in
            completion(result)
        }
    }
    
    func updateAPNSData(_ data: APNSData, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
        let request = UpdateAPNSRequest(theme: theme, apnsData: data)
        service.request(request) { result in
            completion(result)
        }
    }
}
