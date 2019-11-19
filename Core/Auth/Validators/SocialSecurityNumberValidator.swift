//
//  SocialSecurityNumberValidator.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum SSNValidationError: ValidationError {
    case noSSNEntered
    case notAValidSSN
    
    var errorMessage: String {
        switch self {
        case .noSSNEntered:
            return SignUp.ErrorMessage.enterASSN
        case .notAValidSSN:
            return SignUp.ErrorMessage.notAValidSSN
        }
    }
}

struct SSNValidator: Validator {
    func validate(_ field: String?) -> Result<String> {
        guard let ssn = field else {
            return .failure(SSNValidationError.noSSNEntered)
        }
        
        let sanitizedSSN = ssn.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        
        guard isValid(ssn: sanitizedSSN) else {
            return .failure(SSNValidationError.notAValidSSN)
        }
        
        return .success(sanitizedSSN)
    }
    
    private func isValid(ssn: String) -> Bool {
       // SSN should be 9 characters.
       guard ssn.count == 9 else { return false }
       // SSN should contain only numerical digits.
       guard let _ = Int(ssn) else { return false }
       
       return true
   }
}
