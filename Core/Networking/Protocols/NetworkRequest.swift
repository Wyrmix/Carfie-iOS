//
//  NetworkRequest.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol NetworkRequest {
    associatedtype Response: Codable
    
    var baseURL: URL { get }
    var path: String { get }
    var fullURL: URL { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension NetworkRequest {
    var fullURL: URL {
        return baseURL.appendingPathComponent(path)
    }
}

extension NetworkRequest {
    /// Base url for all Carfie API requests
    var baseURL: URL {
        return URL(string: "https://espyinnovation.com")!
    }
}
