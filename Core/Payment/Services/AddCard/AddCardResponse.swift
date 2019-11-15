//
//  AddCardResponse.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/8/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum CardAction: String, Codable {
    case cardAdded = "Card Added"
}

struct AddCardResponse: Codable {
    let cardAction: CardAction
    
    enum CodingKeys: String, CodingKey {
        case cardAction = "message"
    }
}
