//
//  DriverIdentification.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/24/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct DriverIdentification: Codable {
    let ssn: String
    let vehicleIdentification: VehicleIdentification
    
    enum CodingKeys: String, CodingKey {
        case ssn
        case vehicleIdentification = "service"
    }
}

struct VehicleIdentification: Codable {
    let model: String
    let number: String
    let type: VehicleType
    
    enum CodingKeys: String, CodingKey {
        case model = "service_model"
        case number = "service_number"
        case type = "service_type_id"
    }
}
