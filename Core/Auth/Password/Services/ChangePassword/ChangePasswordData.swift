//
//  ChangePasswordData.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/16/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct ChangePasswordData: Codable {
    
    /// User's ID.
    let id: Int
    
    /// Old password or OTP if it's a password update or reset respectively.
    let oldPassword: String
    
    /// New password.
    let newPassword: String
    
    /// Confirmation of new password.
    let confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case oldPassword = "old_password"
        case newPassword = "password"
        case confirmPassword = "password_confirmation"
    }
}
