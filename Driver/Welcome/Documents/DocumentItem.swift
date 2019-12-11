//
//  DocumentViewModel.swift
//  Driver
//
//  Created by Christopher Olsen on 11/8/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct DocumentItem {
    let type: DriverDocumentType
    let title: String
    
    var isUploaded: Bool
    var image: UIImage?
}
