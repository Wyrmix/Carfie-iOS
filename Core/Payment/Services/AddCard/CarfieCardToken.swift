//
//  CarfieCard.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/8/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct CarfieCardToken: Codable {
    let stripeToken: String
    
    enum CodingKeys: String, CodingKey {
        case stripeToken = "stripe_token"
    }
}
