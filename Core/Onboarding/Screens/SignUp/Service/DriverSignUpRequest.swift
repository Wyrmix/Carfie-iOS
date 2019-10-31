//
//  DriverSignUpRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct DriverSignUpRequest: NetworkRequest {
    typealias Response = ValidatedSignUp
    
    let path = "/api/provider/register"
    let method: HTTPMethod = .POST
    let task: HTTPTask = .request
    let headers: HTTPHeaders? = nil
}
