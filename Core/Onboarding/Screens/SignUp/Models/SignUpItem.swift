//
//  SignUp.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

/// A representation of sign up fields that require validation.
struct SignUpItem {
    let firstName: String?
    let lastName: String?
    let phone: String?
    let email: String?
    let confirmEmail: String?
    let password: String?
    let confirmPassword: String?
}

/// A representation of the fields required to complete a sign up request.
struct ValidatedSignUp: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let mobile: String
    let password: String
    let passwordConfirmation: String
    
    // TECH-DEBT: These values are necessary for a successful sign up, but never seem to get used.
    // For now I'm hardcoding the values the app has been using.
    let deviceId: String = "no device"
    let deviceToken: String = "no device"
    let deviceType: String = "ios"
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case mobile
        case password
        case passwordConfirmation = "password_confirmation"
        case deviceId = "device_id"
        case deviceToken = "device_token"
        case deviceType = "device_type"
    }
}
