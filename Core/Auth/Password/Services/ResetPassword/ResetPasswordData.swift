//
//  ResetPasswordData.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/16/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct ResetPasswordData: Codable {
    let id: Int
    let otp: String
    let newPassword: String
    let confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case otp = "old_password"
        case newPassword = "password"
        case confirmPassword = "password_confirmation"
    }
}

