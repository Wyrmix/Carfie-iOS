//
//  DocumentsInteractor.swift
//  Driver
//
//  Created by Christopher Olsen on 11/5/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class DocumentsInteractor {
    
    weak var viewController: DocumentsViewController?
    
    private var viewModel: DocumentsViewModel
    
    /// Index of the document for which the user is actively choosing a photo.
    private var indexBeingModified: Int?
    
    private let documentUploadService: UploadImageDataService
    private let allDocumentsAreRequired: Bool
    
    // MARK: Init

    init(
        documentUploadService: UploadImageDataService = UploadDocumentsService(),
        allDocumentsAreRequired: Bool
    ) {
        self.viewModel = DocumentsViewModel()
        self.documentUploadService = documentUploadService
        self.allDocumentsAreRequired = allDocumentsAreRequired
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
        
        viewModel.documentItems[index].isUploaded = true
        viewModel.documentItems[index].image = image
    }
    
    func uploadDocuments() {
        if allDocumentsAreRequired {
            guard viewModel.documentItems.allSatisfy({ $0.image != nil }) else {
                UserFacingErrorIntent(title: "All documents are required", message: "Please add an image for each document type").execute(via: viewController)
                return
            }
        }
        
        var parameters: [String: Int] = [:]
        var images: [String: Data] = [:]
        for item in viewModel.documentItems {
            guard let image = item.image,
                  let imageData = ImageResizer().resize(forUpload: image, withCompressionQualtiy: 0.7) else { continue }
            parameters.updateValue(item.type.rawValue, forKey: "id[\(item.type.rawValue)]")
            images.updateValue(imageData, forKey: "document[\(item.type.rawValue)]")
        }
        
        viewController?.showUploadActivity(true)
        documentUploadService.uploadImages(images, parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            
            self.viewController?.showUploadActivity(false)
            
            switch result {
            case .success:
                // if we're not in onboarding just dismiss.
                guard self.viewController?.onboardingDelegate != nil else {
                    self.viewController?.dismiss(animated: true)
                    return
                }
                self.viewController?.onboardingDelegate?.onboardingScreenComplete()
            case .failure:
                UserFacingErrorIntent(title: "Something went wrong", message: "Please try again.").execute(via: self.viewController)
            }
        }
    }
}

// MARK: - DocumentViewDelegate
extension DocumentsInteractor: DocumentViewDelegate {
    func uploadButtonPressed(for type: DriverDocumentType) {
        guard let presenter = viewController,
              let index = viewModel.documentItems.firstIndex(where: { $0.type == type }) else { return }
        
        indexBeingModified = index
        
        ImagePickerLauncherIntent(libraryCompletion: { _ in
            ImagePickerIntent(for: .photoLibrary)?.execute(via: presenter)
        }, cameraCompletion: { _ in
            ImagePickerIntent(for: .camera)?.execute(via: presenter)
        }).execute(via: presenter)
    }
}
