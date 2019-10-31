//
//  EmptyFieldValidator.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum EmptyFieldValidationError: ValidationError {
    case noTextEntered
    
    var errorMessage: String {
        switch self {
        case .noTextEntered:
            return SignUp.ErrorMessage.requiredField
        }
    }
}

struct EmptyFieldValidator: Validator {
    func validate(_ field: String?) -> Result<String> {
        guard let field = field, !field.isEmpty else { return Result.failure(EmptyFieldValidationError.noTextEntered) }
        return Result.success(field)
    }
}
