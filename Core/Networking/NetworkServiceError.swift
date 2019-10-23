//
//  NetworkServiceError.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum NetworkServiceError: Error {
    case missingParamters
    case encodingFailed
    case decodingFailed
    case missingURL
    case missingData
}
