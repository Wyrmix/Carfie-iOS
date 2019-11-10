//
//  ValidatedSignUp.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/1/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

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
    let deviceId: String = UUID().uuidString // this should eventually be made something idetifiable and unique
    let deviceToken: String = "no device"
    let deviceType: String = "ios"
    let loginBy: String = "manual"
    
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
        case loginBy = "login_by"
    }
}
