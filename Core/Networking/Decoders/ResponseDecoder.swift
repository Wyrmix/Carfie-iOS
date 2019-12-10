//
//  ResponseDecoder.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol ResponseDecoder {
    func decode<T: Decodable>(from data: Data) throws -> T
}
