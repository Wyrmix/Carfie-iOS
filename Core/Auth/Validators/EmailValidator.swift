//
//  AuthValidator.swift
//  CarfieCore
//
//  Created by Christopher Olsen on 9/22/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum EmailValidationError: ValidationError {
    case noEmailEntered
    case notAValidEmail
    
    var errorMessage: String {
        switch self {
        case .noEmailEntered:
            return SignUp.ErrorMessage.enterEmail
        case .notAValidEmail:
            return SignUp.ErrorMessage.enterValidEmail
        }
    }
}

struct EmailValidator: Validator {

    // MARK: - Init

    init() {}

    // MARK: - Public Validators

    func validate(_ field: String?) -> Result<String> {
        guard let email = field else { return Result.failure(EmailValidationError.noEmailEntered) }

        let emailSansWhitespace = email.trimmingCharacters(in: .whitespaces)
        if isValid(email: emailSansWhitespace) {
            return Result.success(emailSansWhitespace)
        }

        return Result.failure(EmailValidationError.notAValidEmail)
    }

    // MARK: - Private Validators

     private func isValid(email: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@","[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: email)
    }
}
