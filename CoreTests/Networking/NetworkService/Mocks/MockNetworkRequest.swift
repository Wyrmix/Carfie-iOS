//
//  MockNetworkRequest.swift
//  CoreTests
//
//  Created by Christopher Olsen on 12/9/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

struct MockNetworkRequest: NetworkRequest {
    typealias Response = MockDecodableObject
    
    let method: HTTPMethod = .GET
    let path = "/getMockRequest"
}
