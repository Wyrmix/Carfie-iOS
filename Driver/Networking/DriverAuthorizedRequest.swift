//
//  DriverAuthorizedRequest.swift
//  Driver
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct DriverAuthorizedRequest<T: Codable>: NetworkRequest {
    typealias Response = T
    
    let path: String
    let method: HTTPMethod
    let task: HTTPTask
    let headers: HTTPHeaders?
    
    init<S: NetworkRequest>(request: S) {
        self.path = request.path
        self.method = request.method
        self.task = request.task
        
        var headers = HTTPHeaders()
        
        if let requestHeaders = request.headers {
            headers.merge(requestHeaders) { (_, new) in new }
        }
        
        // I don't like adding the access token this way, but in the interest of not refactoring everything atm this
        // will live on.
        if let accesstoken = User.main.accessToken{
            headers["Authorization"] = "Bearer \(accesstoken)"
        }
        
        self.headers = headers
    }
}
