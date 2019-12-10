//
//  AddCardRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/8/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct AddCardRequest: NetworkRequest {
    typealias Response = AddCardResponse
    
    var path: String {
        switch theme {
        case .driver:
            return "/api/provider/providercard"
        case .rider:
            return "/api/user/card"
        }
    }
    
    let method: HTTPMethod = .POST
    let isAuthorizedRequest: Bool = true
    let body: Data?
    
    private let theme: AppTheme
    
    init(theme: AppTheme, cardToken: CarfieCardToken) {
        self.theme = theme
        
        do {
            body = try JSONEncoder().encode(cardToken)
        } catch {
            assertionFailure("Card object failed to encode")
            body = nil
        }
    }
}
