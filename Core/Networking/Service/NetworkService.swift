//
//  NetworkService.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol NetworkService {
    
    /// Send a network request using URLSession shared session. The request is built from a NetworkRequest object.
    ///
    /// - Parameters:
    ///   - endpoint: object containing configuration for the request
    ///   - completion: called on success or failure
    func request<T: NetworkRequest>(_ request: T, completion: @escaping (Result<T.Response>) -> Void)
    
    /// Cancels the active session task. e.g. to end long running tasks
    func cancel()
}
