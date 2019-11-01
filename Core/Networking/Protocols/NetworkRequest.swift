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
    var body: Data? { get }
    var isAuthorizedRequest: Bool { get }
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

// Default implementations for lesser used properties
extension NetworkRequest {
    var headers: HTTPHeaders? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
    
    var isAuthorizedRequest: Bool {
        return false
    }
}
