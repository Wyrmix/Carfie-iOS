//
//  NetworkParser.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol NetworkParser {
    static func parse<T: Decodable>(data: Data) throws -> T
}
