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
    
    let path = "/api/provider/verify"
    let method: HTTPMethod = .POST
    
    var task: HTTPTask {
        return .requestParameters(bodyParameters: parameters, urlParameters: nil)
    }
    
    var parameters: Parameters {
        return [
            "email": email,
            "isCardAllowed": true,
            "measurement": "km",
        ]
    }
    
    private let email: String
    
    init(email: String) {
        self.email = email
    }
}
