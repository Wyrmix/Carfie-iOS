//
//  MockNetworkSession.swift
//  CoreTests
//
//  Created by Christopher Olsen on 12/5/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum MockNetworkError: Error {
    case internalServerError
}

class MockNetworkSession: NetworkSession {
    var error: Error? = nil
    var data: Data? = nil
    var sessionDataTask = MockURLSessionDataTask(completion: {})
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, nil, error)
        return sessionDataTask
    }
}
