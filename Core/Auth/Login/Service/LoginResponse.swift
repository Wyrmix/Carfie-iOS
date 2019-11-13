//
//  LoginResponse.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/11/19.
//

import Foundation

struct LoginResponse: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
