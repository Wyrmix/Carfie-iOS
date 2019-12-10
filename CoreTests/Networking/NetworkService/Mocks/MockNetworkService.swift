//
//  MockNetworkService.swift
//  CoreTests
//
//  Created by Christopher Olsen on 11/2/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class MockNetworkService: NetworkService {
    func request<T>(_ request: T, completion: @escaping (Result<T.Response>) -> Void) where T : NetworkRequest {
        
    }
    
    func cancel() {
        
    }
}
