//
//  ChangePasswordRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/16/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct ChangePasswordResponse: Codable {
    let message: String
}

struct ChangePasswordRequest: NetworkRequest {
    typealias Response = ChangePasswordResponse
    
    var path: String {
        #if RIDER
            return "/api/user/forgot/password"
        #else
            return "/api/provider/forgot/password"
        #endif
    }
    
    let method: HTTPMethod = .POST
    let body: Data?
    let isAuthorizedRequest = true
    
    init(changePasswordData: ChangePasswordData) {
        do {
            body = try JSONEncoder().encode(changePasswordData)
        } catch {
            assertionFailure("Email object failed to encode")
            body = nil
        }
    }
}
