//
//  DriverDocumentsPresenter.swift
//  Driver
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class DriverDocumentsPresenter {
    var viewController: DriverDocumentsTableViewController?
    
    func presentDocuments(_ documents: [DriverDocument]) {
        let viewModels = documents.map { DriverDocumentCellViewModel(title: $0.name, image: nil, isAdded: false) }
        viewController?.presentDocument(viewModels: viewModels)
    }
}
