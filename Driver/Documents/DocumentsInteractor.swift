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
    
    /// Index of the document for which the user is actively choosing a photo.
    private var indexBeingModified: Int?
    
    private let documentUploadService: UploadImageDataService
    
    // MARK: Init

    init(documentUploadService: UploadImageDataService = UploadDocumentsService()) {
        self.viewModel = DocumentsViewModel()
        self.documentUploadService = documentUploadService
    }
    
    func start() {
        getDocuments()
    }
    
    // MARK: Internal Functions
    
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
        
        let resizedImage = image.resize(for: CGSize(width: 500, height: 500))
        
        viewModel.documentItems[index].isUploaded = true
        viewModel.documentItems[index].image = resizedImage
    }
    
    func uploadDocuments() {
        guard viewModel.documentItems.allSatisfy({ $0.image != nil }) else {
            if let presenter = viewController {
                UserFacingErrorIntent(title: "All documents are required", message: "Please add an image for each document type").execute(via: presenter)
            }
            return
        }
        
        var parameters: [String: Int] = [:]
        var images: [String: Data] = [:]
        for item in viewModel.documentItems {
            guard let imageData = item.image?.pngData() else { continue }
            parameters.updateValue(item.id, forKey: "id[\(item.id)]")
            images.updateValue(imageData, forKey: "document[\(item.id)]")
        }
        
        documentUploadService.uploadImages(images, parameters: parameters) { result in
            switch result {
            case .success:
                print("yay it worked")
            case .failure(let error):
                // TODO: show alert
                print("oh no: \(error)")
            }
        }
    }
}

// MARK: - DocumentViewDelegate
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
