//
//  MatchingFieldValidator.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum MatchingFieldValidationError: ValidationError {
    case fieldsDoNotMatch
    
    var errorMessage: String {
        switch self {
        case .fieldsDoNotMatch:
            return SignUp.ErrorMessage.fieldsMustMatch
        }
    }
}

struct MatchingFieldValidator: Validator {
    private let fieldToMatch: String?
    
    init(fieldToMatch: String?) {
        self.fieldToMatch = fieldToMatch
    }
    
    func validate(_ field: String?) -> Result<String> {
        guard let field = field,
              let fieldToMatch = fieldToMatch,
              !field.isEmpty,
              !fieldToMatch.isEmpty
        else {
            return Result.failure(EmptyFieldValidationError.noTextEntered)
        }
        
        guard field == fieldToMatch else { return Result.failure(MatchingFieldValidationError.fieldsDoNotMatch) }
        
        return Result.success(field)
    }
}
