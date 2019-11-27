//
//  APNSRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/25/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct UpdateAPNSRequest: NetworkRequest {
    typealias Response = CarfieProfile
    
    var path: String {
        switch theme {
        case .driver:
            return "/api/provider/profile/device/token"
        case .rider:
            return "/api/user/details"
        }
    }
    
    let method: HTTPMethod = .PUT
    let task: HTTPTask = .request
    let isAuthorizedRequest = true
    let body: Data?
    
    let theme: AppTheme
    
    init(theme: AppTheme, apnsData: APNSData) {
        self.theme = theme
        
        do {
            body = try JSONEncoder().encode(apnsData)
        } catch {
            assertionFailure("APNSData object failed to encode")
            body = nil
        }
    }
}
