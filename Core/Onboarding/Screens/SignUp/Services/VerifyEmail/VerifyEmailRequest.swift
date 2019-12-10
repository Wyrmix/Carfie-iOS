//
//  VerifyEmailRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct VerifyEmailRequest: NetworkRequest {
    typealias Response = VerifyEmail
    
    var path: String {
        switch theme {
        case .driver:
            return "/api/provider/verify"
        case .rider:
            return "/api/user/verify"
        }
    }
    
    let method: HTTPMethod = .POST
    
    var parameters: Parameters {
        return [
            "email": email,
            // TECH-DEBT: These properties certainly aren't needed, but are currently required by the service.
            "isCardAllowed": true,
            "measurement": "km",
        ]
    }
    
    private let theme: AppTheme
    private let email: String
    
    init(theme: AppTheme, email: String) {
        self.theme = theme
        self.email = email
    }
}
