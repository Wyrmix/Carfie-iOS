//
//  ForgotPasswordResponse.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct ForgotPasswordResponse: Codable {
    let message: String
    let user: CarfieProfile
}
