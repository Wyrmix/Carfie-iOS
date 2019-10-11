//
//  Validator.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/10/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol ValidationError: Error {
    var errorMessage: String { get }
}

protocol Validator {
    func validate(_ field: String?) -> Result<String>
}

struct FieldValidator {
    
    private let validator: Validator
    
    init(validator: Validator) {
        self.validator = validator
    }
    
    func validate(_ field: String?) -> Result<String> {
        return validator.validate(field)
    }
}
