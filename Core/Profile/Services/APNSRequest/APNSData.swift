//
//  APNSData.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/25/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct APNSData: Codable {
    let firstName: String
    let lastName: String
    let deviceToken: String
    let mobile: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case deviceToken = "device_token"
        case mobile
    }
}
