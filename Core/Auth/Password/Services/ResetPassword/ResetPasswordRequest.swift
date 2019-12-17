//
//  ResetPasswordRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/16/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct ResetPasswordResponse: Codable {
    let message: String
}

struct ResetPasswordRequest: NetworkRequest {
    typealias Response = ResetPasswordResponse
    
    var path: String {
        #if RIDER
            return "/api/user/reset/password"
        #else
            return "/api/provider/reset/password"
        #endif
    }
    
    let method: HTTPMethod = .POST
    let body: Data?
    
    init(changePasswordData: ChangePasswordData) {
        do {
            body = try JSONEncoder().encode(changePasswordData)
        } catch {
            assertionFailure("Email object failed to encode")
            body = nil
        }
    }
}
