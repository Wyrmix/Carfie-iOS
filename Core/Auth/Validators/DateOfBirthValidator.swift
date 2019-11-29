//
//  DateOfBirthValidator.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/29/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum DateOfBirthValidationError: ValidationError {
    case noDOBEntered
    case invalidDOB
    case notTwentyOne
    
    var errorMessage: String {
        switch self {
        case .noDOBEntered:
            return SignUp.ErrorMessage.enterADOB
        case .invalidDOB:
            return SignUp.ErrorMessage.invalidDOB
        case .notTwentyOne:
            return SignUp.ErrorMessage.notTwentyOne
        }
    }
}

struct DateOfBirthValidator: Validator {
    func validate(_ field: String?) -> Result<String> {
        guard let dob = field else {
            return .failure(DateOfBirthValidationError.noDOBEntered)
        }
        
        let sanitizedDOB = dob.replacingOccurrences(of: "-", with: "")
                              .replacingOccurrences(of: " ", with: "")
                              .replacingOccurrences(of: "/", with: "")
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        
        // Must be a valid date
        guard let date = dateFormatter.date(from: sanitizedDOB) else {
            return .failure(DateOfBirthValidationError.invalidDOB)
        }
        
        // Must be 21 years old
        let timeInterval = Date().timeIntervalSince(date)
        let age = timeInterval / 31557600
        guard age >= 21 else {
            return .failure(DateOfBirthValidationError.notTwentyOne)
        }
        
        return .success(sanitizedDOB)
    }
}
