//
//  ProfileRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 espy. All rights reserved.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    typealias Response = CarfieProfile
    
    var path: String {
        switch theme {
        case .driver:
            return "/api/provider/profile"
        case .rider:
            return "/api/user/details"
        }
    }
    
    let method: HTTPMethod = .GET
    let task: HTTPTask = .request
    let isAuthorizedRequest = true
    
    let theme: AppTheme
    
    init(theme: AppTheme) {
        self.theme = theme
    }
}
