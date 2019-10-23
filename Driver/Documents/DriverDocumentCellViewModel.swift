//
//  DriverDocumentCellViewModel.swift
//  Driver
//
//  Created by Christopher Olsen on 10/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct DriverDocumentCellViewModel {
    let title: String
    let image: UIImage?
    let isAdded: Bool
    
    var actionButtonTitle: String {
        switch isAdded {
        case true:
            return "Delete"
        case false:
            return "Add"
        }
    }
}
