//
//  DocumentsViewModel.swift
//  Driver
//
//  Created by Christopher Olsen on 11/10/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct DocumentsViewModel {
    var documentItems: [DocumentItem] = [
        DocumentItem(type: .driversLicenseFront, title: "Driver's License Front", isUploaded: false, image: nil),
        DocumentItem(type: .driversLicenseBack, title: "Driver's License Back", isUploaded: false, image: nil),
        DocumentItem(type: .vehicleRegistration, title: "Vehicle Resgistration", isUploaded: false, image: nil),
        DocumentItem(type: .insurance, title: "Car Insurance", isUploaded: false, image: nil),
    ]
}
