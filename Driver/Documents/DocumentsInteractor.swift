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
    
    private var indexBeingModified: Int?
    
    init() {
        self.viewModel = DocumentsViewModel()
    }
    
    func start() {
        getDocuments()
    }
    
    func getDocuments() {
        viewController?.presentDocuments(from: viewModel)
    }
    
    func updateDocumentWithImage(_ image: UIImage?) {
        guard let index = indexBeingModified else { return }
        
        defer {
            indexBeingModified = nil
            viewController?.presentDocuments(from: viewModel)
        }
        
        guard let image = image else {
            viewModel.documentItems[index].isUploaded = false
            viewModel.documentItems[index].image = nil
            return
        }
        
        viewModel.documentItems[index].isUploaded = true
        viewModel.documentItems[index].image = image
    }
}

extension DocumentsInteractor: DocumentViewDelegate {
    func uploadButtonPressed(for id: Int) {
        guard let presenter = viewController,
              let index = viewModel.documentItems.firstIndex(where: { $0.id == id }) else { return }
        
        indexBeingModified = index
        
        ImagePickerLauncherIntent(libraryCompletion: { _ in
            ImagePickerIntent(for: .photoLibrary)?.execute(via: presenter)
        }, cameraCompletion: { _ in
            ImagePickerIntent(for: .camera)?.execute(via: presenter)
        }).execute(via: presenter)
    }
}
