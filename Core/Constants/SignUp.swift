//
//  SignUp.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/10/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct SignUp {
    struct ErrorMessage {
        // Email
        static let enterEmail = "You must enter an email"
        static let enterValidEmail = "Enter a valid email address"
        
        // Phone number
        static let enterMobileNumber = "You must enter a phone number"
        static let invalidPhoneNumber = "Enter a valid phone number in the format: (XXX) XXX-XXXX"
        
        // Password
        static let mustEnterPassword = "You must enter a password"
        static let passwordTooShort = "Your password must be at least 6 characters"
        static let passwordsDoNotMatch = "Your passwords don't match"
        static let invalidPassword = "Password should contain at least 1 uppercase letter and 1 number"
    }
}
