//
//  ForgotPasswordRequest.swift
//  CoreTests
//
//  Created by Christopher Olsen on 12/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct ForgotPasswordRequest: NetworkRequest {
    typealias Response = ForgotPasswordResponse
    
    var path: String {
        #if RIDER
            return "/api/user/forgot/password"
        #else
            return "/api/provider/forgot/password"
        #endif
    }
    
    let method: HTTPMethod = .POST
    let body: Data?
    
    init(email: String) {
        do {
            body = try JSONEncoder().encode(["email": email])
        } catch {
            assertionFailure("Email object failed to encode")
            body = nil
        }
    }
}
