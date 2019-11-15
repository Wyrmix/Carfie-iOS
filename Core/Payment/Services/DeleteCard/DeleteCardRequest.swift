//
//  DeleteCardRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/14/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct DeleteCardRequest: NetworkRequest {
    typealias Response = DeleteCardResponse
    
    var path: String {
        // why can't this endpoint just be a DELETE using the same route as the rest of the card APIs? 🤷‍♀️
        switch theme {
        case .driver:
            return "/api/provider/card/destory"
        case .rider:
            return "/api/user/card/destory"
        }
    }
    
    var task: HTTPTask {
        return .request
    }
    
    let method: HTTPMethod = .DELETE
    let isAuthorizedRequest: Bool = true
    let body: Data?
    
    private let theme: AppTheme
    
    init(theme: AppTheme, card: CarfieCard) {
        self.theme = theme
        
        do {
            body = try JSONEncoder().encode(card)
        } catch {
            assertionFailure("Card object failed to encode")
            body = nil
        }
    }
}

