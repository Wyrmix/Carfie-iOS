//
//  DriverDocument.swift
//  Driver
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum DriverDocumentType: Int, Codable {
    case driversLicenseFront = 1
    case driversLicenseBack = 2
    case vehicleRegistration = 3
    case insurance = 4
}

struct DriverDocumentList: Codable {
    let documents: [DriverDocument]
}

struct DriverDocument: Codable {
    let id: DriverDocumentType
    let name: String
}
