//
//  DocumentsInteractor.swift
//  Carfie
//
//  Created by Christopher.Olsen on 11/5/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class DocumentsInteractor {
    
    weak var viewController: DocumentsViewController?
    
    private var viewModel: DocumentsViewModel
    
    init() {
        self.viewModel = DocumentsViewModel()
    }
    
    func start() {
        getDocuments()
    }
    
    func getDocuments() {
        viewController?.presentDocuments(from: viewModel)
    }
}

extension DocumentsInteractor: DocumentViewDelegate {
    func uploadButtonPressed(for id: Int) {
        guard let index = viewModel.documentItems.firstIndex(where: { $0.id == id }) else { return }
        var documentItem = viewModel.documentItems[index]
        documentItem.isUploaded = true
        viewModel.documentItems.remove(at: index)
        viewModel.documentItems.insert(documentItem, at: index)
        viewController?.presentDocuments(from: viewModel)
    }
}
