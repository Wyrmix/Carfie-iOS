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
        DocumentItem(id: 1, title: "Driver's License Front", isUploaded: false, image: nil),
        DocumentItem(id: 2, title: "Driver's License Back", isUploaded: false, image: nil),
        DocumentItem(id: 3, title: "Vehicle Resgistration", isUploaded: false, image: nil),
        DocumentItem(id: 4, title: "Car Insurance", isUploaded: false, image: nil),
    ]
}
