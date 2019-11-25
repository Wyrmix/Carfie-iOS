//
//  VehicleType.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/22/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

/// Describes the different Carfie ride experiences. Each case is a specific class of vehicle.
enum VehicleType: Int, Codable, CaseIterable {
    
    case carfie = 1
    case carfieS = 2
    case carfieXL = 3
    case lux = 4
    case luxXL = 7
    
    var description: String {
        switch self {
        case .carfie:
            return "Carfie (4-Seater Everyday rides)"
        case .carfieS:
            return "Carfie S (4-Seater Comfort New)"
        case .carfieXL:
            return "Carfie XL (6-Seater SUV)"
        case .lux:
            return "Lux (4-Seater Luxury High-end)"
        case .luxXL:
            return "Lux XL (6-Seater Luxury High-end)"
        }
    }
}
