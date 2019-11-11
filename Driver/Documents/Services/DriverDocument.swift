//
//  DriverDocument.swift
//  Driver
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

enum DriverDocumentType: Int, Codable {
    // These are used by the app currently
    case driversLicenseFront = 8
    case driversLicenseBack = 9
    case vehicleRegistration = 5
    case insurance = 6
    case licensePlate = 10
    
    // These are not currently used, but are still returned in the response
    // and thus need to be included to allow decoding.
    case driversLicense = 1
    case joiningForm = 3
    case workPermit = 4
    case fitnessCertificate = 7
}

struct DriverDocumentList: Codable {
    let documents: [DriverDocument]
}

struct DriverDocument: Codable {
    let id: DriverDocumentType
    let name: String
}
