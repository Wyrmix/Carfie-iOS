//
//  CardEntity.swift
//  User
//
//  Created by CSS on 23/07/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct CardEntity : JSONSerializable {
    var id : Int?
    var last_four : String?
    var card_id : String?
    var is_default : Int?
    var stripe_token : String?
    var _method : String?
    var strCardID : String?
    var amount : String?
}

extension CardEntity {
    
    /// This init bridges the two disparate card data models until we can condense them into one.
    init(_ card: CarfieCard) {
        self.id = card.id
        self.last_four = card.lastFour
        self.card_id = card.cardId
        self.is_default = card.isDefault
    }
}
