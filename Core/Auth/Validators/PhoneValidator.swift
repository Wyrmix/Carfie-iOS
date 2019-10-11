//
//  PhoneValidator.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/10/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum PhoneValidationError: ValidationError {
    case noPhoneNumberEntered
    case notAValidPhoneNumber
    
    var errorMessage: String {
        switch self {
        case .noPhoneNumberEntered:
            return SignUp.ErrorMessage.enterMobileNumber
        case .notAValidPhoneNumber:
            return SignUp.ErrorMessage.invalidPhoneNumber
        }
    }
}

struct PhoneValidator: Validator {
    
    // MARK: - Init

    init() {}

    // MARK: - Public Validators

    func validate(_ field: String?) -> Result<String> {
        guard let phone = field else { return Result.failure(PhoneValidationError.noPhoneNumberEntered) }

        let phoneSansWhitespace = phone.trimmingCharacters(in: .whitespaces)
        let sanitizedPhoneNumber = phoneSansWhitespace.replacingOccurrences(of: "-", with: "")
                                                      .replacingOccurrences(of: " ", with: "")
                                                      .replacingOccurrences(of: "(", with: "")
                                                      .replacingOccurrences(of: ")", with: "")
        
        guard isValid(phone: sanitizedPhoneNumber) else {
            return Result.failure(PhoneValidationError.notAValidPhoneNumber)
        }

        return Result.success(sanitizedPhoneNumber)
    }

    // MARK: - Private Validators

     private func isValid(phone: String) -> Bool {
        // phone number should be 10 characters: 3 digit area code + 7 digit phone number.
        guard phone.count == 10 else { return false }
        // phone number should contain only numerical digits.
        guard let _ = Int(phone) else { return false }
        
        return true
    }
}
