//
//  JSONParser.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Alamofire
import Foundation

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            return .failure(NetworkServiceError.missingData)
        }
        
        do {
            let result = try decode(T.self, from: responseData)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
