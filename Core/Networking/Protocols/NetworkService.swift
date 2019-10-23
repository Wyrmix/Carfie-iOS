//
//  NetworkService.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol NetworkService {
    func request<T: NetworkRequest>(_ request: T, completion: @escaping (Result<T.Response>) -> Void)
    func cancel()
}
