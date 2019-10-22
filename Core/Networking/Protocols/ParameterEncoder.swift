//
//  ParameterEncoder.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]

protocol ParameterEncoder {
    static func encode(request: inout URLRequest, with parameters: Parameters) throws
}

