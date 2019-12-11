//
//  MockProfileService.swift
//  CoreTests
//
//  Created by Christopher Olsen on 11/2/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class MockProfileService: ProfileService {
    func getProfile(theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
        
    }
    
    func updateProfile(_ profile: CarfieProfile, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
        
    }
    
    func updateDriverIdentification(_ identification: DriverIdentification, completion: @escaping (Result<CarfieProfile>) -> Void) {
        let service = CarfieService(
            service: nil,
            providerId: nil,
            vehicleModel: identification.vehicleIdentification.model,
            vehicleNumber: identification.vehicleIdentification.number,
            serviceTypeId: identification.vehicleIdentification.type,
            serviceType: nil
        )
        
        let profile = CarfieProfile(id: 1, firstName: "Luke", lastName: "Skywalker", email: "luke@jedicouncil.org", mobile: "999-999-9999", service: service)
        completion(.success(profile))
    }
    
    func updateAPNSData(_ data: APNSData, theme: AppTheme, completion: @escaping (Result<CarfieProfile>) -> Void) {
        
    }
}
