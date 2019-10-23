//
//  JSONParameterEncoder.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

/// Encode JSON parameters for URL request body.
class JSONParameterEncoder: ParameterEncoder {
    
    static func encode(request: inout URLRequest, with parameters: Parameters) throws {
        guard request.url != nil else { throw NetworkServiceError.missingURL }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            throw NetworkServiceError.encodingFailed
        }
    }
}
