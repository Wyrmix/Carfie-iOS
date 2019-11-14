//
//  CarfieCard.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/13/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct CarfieCard: Codable {
    let id: Int
    let userId: Int
    let lastFour: String
    let cardId: String
    let brand: String
    let isDefault: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case lastFour = "last_four"
        case cardId = "card_id"
        case brand
        case isDefault = "is_default"
    }
}
