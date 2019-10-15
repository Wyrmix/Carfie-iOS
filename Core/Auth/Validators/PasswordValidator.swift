//
//  PasswordValidator.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/12/19.
//

import Foundation

enum PasswordValidationError: ValidationError {
    case empty
    case tooShort
    case invalidPassword
    
    var errorMessage: String {
        switch self {
        case .empty:
            return SignUp.ErrorMessage.mustEnterPassword
        case .tooShort:
            return SignUp.ErrorMessage.passwordTooShort
        case .invalidPassword:
            return SignUp.ErrorMessage.invalidPassword
        }
    }
}

struct PasswordValidator: Validator {
    
    // MARK: - Public Validators
    
    func validate(_ field: String?) -> Result<String> {
        // password should no be nil
        guard let password = field else { return Result.failure(PasswordValidationError.empty) }
        
        let sanitizedPassword = password.trimmingCharacters(in: .whitespaces)
        
        // password should be at least 8 chaarcters
        guard sanitizedPassword.count > 7 else { return Result.failure(PasswordValidationError.tooShort) }
        
        // password should contain letters, numbers, and at least one uppercase letter
        guard containsLettersAndNumbers(sanitizedPassword), containsUppercaseCharacter(sanitizedPassword) else {
            return Result.failure(PasswordValidationError.invalidPassword)
        }
        
        return Result.success(sanitizedPassword)
    }
    
    private func containsUppercaseCharacter(_ password: String) -> Bool {
        let uppercaseCharacters = password.filter { $0.isUppercase }
        return !uppercaseCharacters.isEmpty
    }
    
    private func containsLettersAndNumbers(_ password: String) -> Bool {
        let numbers = password.filter { $0.isNumber }
        let letters = password.filter { $0.isLetter }
        return !numbers.isEmpty && !letters.isEmpty
    }
}
