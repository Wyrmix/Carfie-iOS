//
//  APNSData.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/25/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct APNSData: Codable {
    let deviceToken: String
    
    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
    }
}
