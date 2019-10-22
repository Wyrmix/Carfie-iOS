//
//  JSONParser.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

/// Decode data into an object of Type T that conforms to Decodable.
class JSONParser: NetworkParser {
    
    static func parse<T: Decodable>(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkServiceError.decodingFailed
        }
    }
}
