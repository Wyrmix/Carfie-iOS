//
//  SignUpResponse.swift
//  CoreTests
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 espy. All rights reserved.
//

import Foundation

struct SignUpResponse: Codable {
    let id: Int
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case accessToken = "access_token"
    }
}
