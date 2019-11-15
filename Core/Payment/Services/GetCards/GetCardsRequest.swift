//
//  GetCardsRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/13/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct GetCardsRequest: NetworkRequest {
    typealias Response = GetCardsResponse
    
    var path: String {
        switch theme {
        case .driver:
            return "/api/provider/providercard"
        case .rider:
            return "/api/user/card"
        }
    }
    
    var task: HTTPTask {
        return .request
    }
    
    let method: HTTPMethod = .GET
    let parameters: Parameters = [:]
    let isAuthorizedRequest: Bool = true
    
    private let theme: AppTheme
    
    init(theme: AppTheme) {
        self.theme = theme
    }
}
