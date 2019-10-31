//
//  SignUpRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/31/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct RiderSignUpRequest: NetworkRequest {
    typealias Response = ValidatedSignUp
    
    let path = "/api/user/signup"
    let method: HTTPMethod = .POST
    let task: HTTPTask = .request
    let headers: HTTPHeaders? = nil
}
