//
//  DriverDocument.swift
//  Driver
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct DriverDocumentList: Codable {
    let documents: [DriverDocument]
}

struct DriverDocument: Codable {
    let name: String
}
