//
//  VehicleYearValidator.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/11/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum VehicleYearValidationError: ValidationError {
    case noYearEntered
    case notAValidYear
    
    var errorMessage: String {
        switch self {
        case .noYearEntered:
            return SignUp.ErrorMessage.enterAVehicleYear
        case .notAValidYear:
            return SignUp.ErrorMessage.notAValidYear
        }
    }
}

struct VehicleYearValidator: Validator {
    func validate(_ field: String?) -> Result<String> {
        guard let year = field else {
            return .failure(VehicleYearValidationError.noYearEntered)
        }
        
        let sanitizedYear = year.components(separatedBy: .whitespaces).joined()
        
        guard let numericalYear = Int(sanitizedYear),
                  DateComponents(year: numericalYear).isValidDate(in: Calendar.current) else {
            return .failure(VehicleYearValidationError.notAValidYear)
        }
        
        return .success(sanitizedYear)
    }
}
