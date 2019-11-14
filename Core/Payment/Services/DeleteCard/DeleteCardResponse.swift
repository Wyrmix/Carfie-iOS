//
//  DeleteCardResponse.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/14/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum DeleteCardResult: String, Codable {
    case success = "Card Deleted"
}

struct DeleteCardResponse: Codable {
    let message: DeleteCardResult
}
