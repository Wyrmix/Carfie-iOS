//
//  VerifyEmailResponse.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum VerifyEmailMessage: String, Codable {
    case available = "Email Available"
}

struct VerifyEmail: Codable {
    let message: VerifyEmailMessage
}
