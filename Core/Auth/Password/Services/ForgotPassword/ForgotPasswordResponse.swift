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
    
    enum CodingKeys: String, CodingKey {
        case message
        
        #if RIDER
        case user
        #else
        case user = "provider"
        #endif
    }
}
