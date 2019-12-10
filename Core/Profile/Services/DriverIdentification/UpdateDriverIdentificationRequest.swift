//
//  UpdateDriverIdentificationRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/25/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct UpdateDriverIdentificationRequest: NetworkRequest {
    typealias Response = CarfieProfile
    
    var path: String {
        return "/api/provider/profile"
    }
    
    let method: HTTPMethod = .POST
    let isAuthorizedRequest = true
    let body: Data?
    
    init(identification: DriverIdentification) {
        do {
            body = try JSONEncoder().encode(identification)
        } catch {
            assertionFailure("Driver Identification object failed to encode")
            body = nil
        }
    }
}

