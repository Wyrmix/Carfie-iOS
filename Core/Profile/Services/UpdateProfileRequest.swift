//
//  UpdateProfileRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    typealias Response = CarfieProfile
    
    var path: String {
        #if RIDER
            return "/api/user/update/profile"
        #else
            return "/api/provider/profile"
        #endif
    }
    
    let method: HTTPMethod = .POST
    let isAuthorizedRequest = true
    let body: Data?
    
    init(profile: CarfieProfile) {
        do {
            body = try JSONEncoder().encode(profile)
        } catch {
            assertionFailure("Profile object failed to encode")
            body = nil
        }
    }
}
