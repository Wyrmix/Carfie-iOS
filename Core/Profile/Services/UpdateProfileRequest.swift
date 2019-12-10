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
        switch theme {
        case .driver:
            return "/api/provider/profile"
        case .rider:
            return "/api/user/update/profile"
        }
    }
    
    let method: HTTPMethod = .POST
    let isAuthorizedRequest = true
    let body: Data?
    
    let theme: AppTheme
    
    init(theme: AppTheme, profile: CarfieProfile) {
        self.theme = theme
        
        do {
            body = try JSONEncoder().encode(profile)
        } catch {
            assertionFailure("Profile object failed to encode")
            body = nil
        }
    }
}
